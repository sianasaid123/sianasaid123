# 🏥 PharmaMa - دليل الأدوية المغربي 🇲🇦

<div align="center">

**Moroccan Pharmacy Guide App** | **دليل الأدوية المغربي** | **Guide Pharmaceutique Marocain**

A comprehensive Flutter application for browsing Moroccan medications with descriptions in **Arabic/Darija** and **French**.

</div>

---

## ✨ Features

- 🔍 **Fast Search**: Search medications by name or category in Arabic/French
- 💊 **20+ Medications**: Pre-loaded database of common Moroccan medicines with PPM prices
- 🏷️ **Category Filter**: Browse by categories (Painkillers, Antibiotics, Vitamins, etc.)
- 📋 **Detailed Info**: Full description with indications and "How to use" in Darija/Arabic
- 💰 **Moroccan Prices**: All prices in DH (Dirhams) matching PPM (Prix Public Maroc)
- 🌐 **Bilingual**: Toggle between Arabic/Darija and French with one tap
- 📱 **Professional UI**: Clean medical color palette (Emerald Green, White, Light Blue)
- ⚕️ **Prescription Badge**: Clear marking for medications requiring a prescription

## 🎨 UI Design

| Color | Usage |
|-------|-------|
| Emerald Green (#2E7D32) | Primary, AppBar, Buttons |
| Light Blue (#03A9F4) | Secondary accents |
| White (#FFFFFF) | Cards, backgrounds |
| Light Background (#F5F9F6) | Scaffold |

## 🗂️ Project Structure

```
lib/
├── main.dart                 # App entry + Splash screen
├── models/
│   └── medication.dart       # Medication data model
├── database/
│   └── database_helper.dart  # SQLite DB + seed data (20 medicines)
├── screens/
│   ├── home_screen.dart      # Home with search & category filter
│   └── detail_screen.dart    # Medicine detail page
├── widgets/
│   ├── medication_card.dart  # Medicine list card
│   └── category_chip.dart    # Category filter chip
├── utils/
│   ├── app_colors.dart       # Color palette constants
│   └── app_theme.dart        # Material theme config
└── l10n/
    ├── app_ar.arb            # Arabic translations
    └── app_fr.arb            # French translations
```

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Database**: SQLite (sqflite)
- **Localization**: ARB files (Arabic + French)
- **Font**: Cairo (Arabic-friendly)
- **State**: setState (lightweight, no overkill)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Android Studio or VS Code with Flutter extension

### Installation

```bash
# Clone the repository
git clone https://github.com/sianasaid123/spharmacy_ma.git
cd spharmacy_ma

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## 📦 Data Import

See [`docs/DATA_IMPORT_GUIDE.md`](docs/DATA_IMPORT_GUIDE.md) for instructions on:
- Scraping data from ANAM / Medicament.ma
- Importing from CSV/JSON
- Updating PPM prices

## 🇲🇦 Moroccan Context

- Currency displayed as **DH** (Dirhams) or **درهم**
- Prices match **PPM** (Prix Public Maroc) regulated by the Ministry of Health
- Medical instructions written in simplified **Darija** (Moroccan Arabic) for accessibility
- Categories follow Moroccan pharmacy classification

## 📋 Seed Data Categories

| العربية | Français | Count |
|---------|----------|-------|
| مسكنات الألم | Antalgiques / Antispasmodiques | 4 |
| مضادات حيوية | Antibiotiques | 3 |
| مضادات الالتهاب | Anti-inflammatoires | 2 |
| أمراض المعدة | Gastro-entérologie | 3 |
| أمراض التنفس | Pneumologie / ORL | 3 |
| فيتامينات | Vitamines | 3 |
| أمراض الجلد | Dermatologie | 1 |
| طفيليات | Antiparasitaires | 1 |

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

**© Jellouli Said 2026** — Made with ❤️ in Morocco 🇲🇦

</div>
