// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'PharmaMa';

  @override
  String get searchHint => 'Rechercher un médicament...';

  @override
  String get medications => 'Médicaments';

  @override
  String get categories => 'Catégories';

  @override
  String get indications => 'Indications';

  @override
  String get howToUse => 'Comment l\'utiliser';

  @override
  String get dosage => 'Dosage';

  @override
  String get price => 'Prix';

  @override
  String get prescriptionRequired => 'Ordonnance requise';

  @override
  String get noResults => 'Aucun médicament trouvé';

  @override
  String get disclaimer => 'Informations à titre éducatif uniquement';

  @override
  String get language => 'عربي';

  @override
  String get currency => 'DH';
}
