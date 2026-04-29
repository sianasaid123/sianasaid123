class Medication {
  final int? id;
  final String name;
  final String nameFr;
  final double price;
  final String? imageUrl;
  final String category;
  final String categoryFr;
  final String indicationsAr;
  final String indicationsFr;
  final String howToUseAr;
  final String howToUseFr;
  final String dosage;
  final bool prescriptionRequired;
  final String source;
  final String? form;
  final String? packaging;
  final String? manufacturer;
  final String? detailUrl;
  final double? priceHospital;
  final double? pricePara;

  Medication({
    this.id,
    required this.name,
    required this.nameFr,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.categoryFr,
    required this.indicationsAr,
    required this.indicationsFr,
    required this.howToUseAr,
    required this.howToUseFr,
    required this.dosage,
    this.prescriptionRequired = false,
    this.source = 'seed',
    this.form,
    this.packaging,
    this.manufacturer,
    this.detailUrl,
    this.priceHospital,
    this.pricePara,
  });

  bool get isFromOnline => source == 'medicament_ma';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_fr': nameFr,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'category_fr': categoryFr,
      'indications_ar': indicationsAr,
      'indications_fr': indicationsFr,
      'how_to_use_ar': howToUseAr,
      'how_to_use_fr': howToUseFr,
      'dosage': dosage,
      'prescription_required': prescriptionRequired ? 1 : 0,
      'source': source,
      'form': form,
      'packaging': packaging,
      'manufacturer': manufacturer,
      'detail_url': detailUrl,
      'price_hospital': priceHospital,
      'price_para': pricePara,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      nameFr: map['name_fr'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] as String?,
      category: map['category'] as String,
      categoryFr: map['category_fr'] as String,
      indicationsAr: (map['indications_ar'] as String?) ?? '',
      indicationsFr: (map['indications_fr'] as String?) ?? '',
      howToUseAr: (map['how_to_use_ar'] as String?) ?? '',
      howToUseFr: (map['how_to_use_fr'] as String?) ?? '',
      dosage: (map['dosage'] as String?) ?? '',
      prescriptionRequired: map['prescription_required'] == 1,
      source: (map['source'] as String?) ?? 'seed',
      form: map['form'] as String?,
      packaging: map['packaging'] as String?,
      manufacturer: map['manufacturer'] as String?,
      detailUrl: map['detail_url'] as String?,
      priceHospital: map['price_hospital'] != null
          ? (map['price_hospital'] as num).toDouble()
          : null,
      pricePara: map['price_para'] != null
          ? (map['price_para'] as num).toDouble()
          : null,
    );
  }

  factory Medication.fromOnline({
    required String nameFr,
    required double ppv,
    String? form,
    String? packaging,
    String? manufacturer,
    String? detailUrl,
    bool prescriptionRequired = false,
    double? priceHospital,
    double? pricePara,
  }) {
    return Medication(
      name: nameFr,
      nameFr: nameFr,
      price: ppv,
      category: _detectCategory(nameFr, form ?? ''),
      categoryFr: _detectCategoryFr(nameFr, form ?? ''),
      indicationsAr: '',
      indicationsFr: '',
      howToUseAr: '',
      howToUseFr: '',
      dosage: '',
      prescriptionRequired: prescriptionRequired,
      source: 'medicament_ma',
      form: form,
      packaging: packaging,
      manufacturer: manufacturer,
      detailUrl: detailUrl,
      priceHospital: priceHospital,
      pricePara: pricePara,
    );
  }

  static String _detectCategory(String name, String form) {
    final n = name.toLowerCase();
    final f = form.toLowerCase();
    if (_matchesVitamins(n)) { return 'فيتامينات'; }
    if (_matchesAntibiotics(n)) { return 'مضادات حيوية'; }
    if (_matchesAntiInflam(n)) { return 'مضادات الالتهاب'; }
    if (_matchesPainkillers(n)) { return 'مسكنات الألم'; }
    if (_matchesGastro(n)) { return 'أمراض المعدة'; }
    if (_matchesRespiratory(n)) { return 'أمراض التنفس'; }
    if (_matchesDerma(n, f)) { return 'أمراض الجلد'; }
    return 'أدوية أخرى';
  }

  static String _detectCategoryFr(String name, String form) {
    final n = name.toLowerCase();
    final f = form.toLowerCase();
    if (_matchesVitamins(n)) { return 'Vitamines'; }
    if (_matchesAntibiotics(n)) { return 'Antibiotiques'; }
    if (_matchesAntiInflam(n)) { return 'Anti-inflammatoires'; }
    if (_matchesPainkillers(n)) { return 'Antalgiques'; }
    if (_matchesGastro(n)) { return 'Gastro-entérologie'; }
    if (_matchesRespiratory(n)) { return 'Pneumologie'; }
    if (_matchesDerma(n, f)) { return 'Dermatologie'; }
    return 'Autres médicaments';
  }

  static bool _matchesVitamins(String n) {
    return n.contains('vitamine') || n.contains('fer ') || n.contains('zinc') ||
        n.contains('calcium') || n.contains('magnesium') || n.contains('d-cure') ||
        n.contains('d3') || n.contains('acfol');
  }

  static bool _matchesAntibiotics(String n) {
    return n.contains('amoxicilline') || n.contains('azithro') || n.contains('cefixime') ||
        n.contains('ciproflox') || n.contains('augmentin') || n.contains('aclav');
  }

  static bool _matchesAntiInflam(String n) {
    return n.contains('ibupro') || n.contains('diclofenac') || n.contains('ketopro');
  }

  static bool _matchesPainkillers(String n) {
    return n.contains('paracetam') || n.contains('doliprane') || n.contains('efferalgan') ||
        n.contains('tramadol') || n.contains('codeine');
  }

  static bool _matchesGastro(String n) {
    return n.contains('omeprazole') || n.contains('pantoprazole') || n.contains('gaviscon') ||
        n.contains('smecta') || n.contains('domperi');
  }

  static bool _matchesRespiratory(String n) {
    return n.contains('salbutamol') || n.contains('ventoline') || n.contains('aerius') ||
        n.contains('cetirizine') || n.contains('desloratadine');
  }

  static bool _matchesDerma(String n, String f) {
    return f.contains('crème') || f.contains('pommade') || f.contains('gel dermique') ||
        n.contains('betamethasone') || n.contains('fusidique');
  }

  String get priceFormatted => '${price.toStringAsFixed(2)} DH';
  String get priceDirham => '${price.toStringAsFixed(2)} درهم';
}
