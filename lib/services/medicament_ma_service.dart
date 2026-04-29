import 'package:http/http.dart' as http;
import '../models/medication.dart';

class MedicamentMaParser {
  static const String baseUrl = 'https://medicament.ma/listing-des-medicaments/';
  static const List<String> letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  final http.Client _client;

  MedicamentMaParser({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<SyncResult> fetchAllMedications({
    void Function(String letter, int page, int totalPages)? onProgress,
    void Function(String letter, int count)? onLetterComplete,
  }) async {
    final allMedications = <Medication>[];
    var totalFetched = 0;

    for (final letter in letters) {
      try {
        final meds = await fetchMedicationsForLetter(
          letter,
          onProgress: onProgress,
        );
        allMedications.addAll(meds);
        totalFetched += meds.length;
        onLetterComplete?.call(letter, meds.length);
      } catch (e) {
        // Continue with next letter on error
      }
    }

    return SyncResult(
      medications: allMedications,
      totalFetched: totalFetched,
      timestamp: DateTime.now(),
    );
  }

  Future<List<Medication>> fetchMedicationsForLetter(
    String letter, {
    void Function(String letter, int page, int totalPages)? onProgress,
  }) async {
    final medications = <Medication>[];
    var page = 1;
    var hasMore = true;

    while (hasMore) {
      final url = page == 1
          ? '$baseUrl?lettre=$letter'
          : '${baseUrl}page/$page/?lettre=$letter';

      try {
        final response = await _client.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'PharmaMa/1.0 (Moroccan Pharmacy Guide)',
            'Accept': 'text/html',
          },
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode != 200) break;

        final html = response.body;
        final pageMeds = _parseListingPage(html);

        if (pageMeds.isEmpty) break;

        medications.addAll(pageMeds);

        final totalPages = _extractTotalPages(html);
        onProgress?.call(letter, page, totalPages);

        hasMore = page < totalPages;
        page++;

        // Rate limiting
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        break;
      }
    }

    return medications;
  }

  List<Medication> _parseListingPage(String html) {
    final medications = <Medication>[];
    final itemPattern = RegExp(
      r'<li\s+class="listing-item">\s*<a\s+href="([^"]*)">\s*<p\s+class="primary">([^<]*)</p>\s*<span\s+class="secondary">([^<]*)</span>',
      multiLine: true,
    );

    for (final match in itemPattern.allMatches(html)) {
      try {
        final detailUrl = match.group(1) ?? '';
        final primaryText = _decodeHtmlEntities(match.group(2) ?? '');
        final secondaryText = _decodeHtmlEntities(match.group(3) ?? '');

        final med = _parseMedicationEntry(primaryText, secondaryText, detailUrl);
        if (med != null) {
          medications.add(med);
        }
      } catch (_) {
        continue;
      }
    }

    return medications;
  }

  Medication? _parseMedicationEntry(
    String primary,
    String secondary,
    String detailUrl,
  ) {
    // Primary: "NAME, FORM" or just "NAME"
    String nameFr;
    String? form;

    final commaIndex = primary.indexOf(',');
    if (commaIndex != -1) {
      nameFr = primary.substring(0, commaIndex).trim();
      form = primary.substring(commaIndex + 1).trim();
    } else {
      nameFr = primary.trim();
    }

    if (nameFr.isEmpty) return null;

    // Secondary: "PACKAGING - PPV: XX.XX dhs - PH: XX.XX dhs - MANUFACTURER"
    final parts = secondary.split(' - ');
    String? packaging;
    double ppv = 0;
    double? priceHospital;
    double? pricePara;
    String? manufacturer;
    bool prescriptionRequired = false;

    if (parts.isNotEmpty) {
      packaging = parts[0].trim();
    }

    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.startsWith('PPV:')) {
        ppv = _extractPrice(trimmed);
      } else if (trimmed.startsWith('PH:')) {
        priceHospital = _extractPrice(trimmed);
      } else if (trimmed.startsWith('PPC:')) {
        pricePara = _extractPrice(trimmed);
        if (ppv == 0) ppv = pricePara;
      }
    }

    // Last non-price part is manufacturer
    if (parts.length >= 2) {
      final lastPart = parts.last.trim();
      if (!lastPart.startsWith('PPV:') &&
          !lastPart.startsWith('PH:') &&
          !lastPart.startsWith('PPC:') &&
          !lastPart.contains('dhs')) {
        manufacturer = lastPart;
      }
    }

    // Check for prescription markers in primary text
    if (primary.contains('[P]') || primary.contains('[SS]')) {
      prescriptionRequired = true;
      nameFr = nameFr.replaceAll('[P]', '').replaceAll('[SS]', '').trim();
    }

    if (ppv == 0 && pricePara == null && priceHospital == null) return null;

    return Medication.fromOnline(
      nameFr: nameFr,
      ppv: ppv > 0 ? ppv : (pricePara ?? priceHospital ?? 0),
      form: form,
      packaging: packaging,
      manufacturer: manufacturer,
      detailUrl: detailUrl,
      prescriptionRequired: prescriptionRequired,
      priceHospital: priceHospital,
      pricePara: pricePara,
    );
  }

  double _extractPrice(String text) {
    final pricePattern = RegExp(r'(\d+(?:\.\d+)?)');
    final match = pricePattern.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }

  int _extractTotalPages(String html) {
    // Find the last page number from pagination
    final pagePattern = RegExp(
      r'<li\s+class="page-item"><a\s+class="page-link\s*"\s+href="[^"]*">(\d+)</a></li>',
    );
    int maxPage = 1;
    for (final match in pagePattern.allMatches(html)) {
      final pageNum = int.tryParse(match.group(1) ?? '1') ?? 1;
      if (pageNum > maxPage) maxPage = pageNum;
    }

    // Also check for the last-page link with &raquo;
    final lastPagePattern = RegExp(
      r'page/(\d+)/\?lettre=\w"><span>&raquo;',
    );
    final lastMatch = lastPagePattern.firstMatch(html);
    if (lastMatch != null) {
      final lastPage = int.tryParse(lastMatch.group(1) ?? '1') ?? 1;
      if (lastPage > maxPage) maxPage = lastPage;
    }

    return maxPage;
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rdquo;', '"')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&raquo;', '\u00BB')
        .replaceAll('&laquo;', '\u00AB')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&eacute;', '\u00E9')
        .replaceAll('&egrave;', '\u00E8')
        .replaceAll('&agrave;', '\u00E0')
        .replaceAll('&ccedil;', '\u00E7')
        .replaceAll('&ocirc;', '\u00F4')
        .replaceAll('&ucirc;', '\u00FB')
        .replaceAll('&iuml;', '\u00EF')
        .replaceAll('&euml;', '\u00EB')
        .trim();
  }
}

class SyncResult {
  final List<Medication> medications;
  final int totalFetched;
  final DateTime timestamp;

  SyncResult({
    required this.medications,
    required this.totalFetched,
    required this.timestamp,
  });
}
