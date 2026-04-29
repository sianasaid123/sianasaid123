# 📦 دليل استيراد بيانات الأدوية المغربية
# Guide d'importation des données médicamenteuses marocaines

## المصادر الرسمية / Sources Officielles

### 1. ANAM (الوكالة الوطنية للتأمين الصحي)
- **الموقع / Site**: [https://www.anam.ma](https://www.anam.ma)
- **البيانات المتاحة / Données disponibles**: 
  - لائحة الأدوية القابلة للتعويض
  - Liste des médicaments remboursables
  - الأثمنة المرجعية / Prix de référence

### 2. Medicament.ma
- **الموقع / Site**: [https://www.medicament.ma](https://www.medicament.ma)
- **البيانات المتاحة / Données disponibles**:
  - قاعدة بيانات شاملة للأدوية في المغرب
  - Base de données complète des médicaments au Maroc
  - PPM (Prix Public Maroc)
  - DCI (Dénomination Commune Internationale)

### 3. Ministère de la Santé
- **الموقع / Site**: [https://www.sante.gov.ma](https://www.sante.gov.ma)
- **البيانات المتاحة / Données disponibles**:
  - التسعيرة الوطنية المرجعية للأدوية
  - Tarif National de Référence des Médicaments

---

## طريقة الاستيراد / Méthode d'importation

### Option 1: Web Scraping (Python)

```python
import requests
from bs4 import BeautifulSoup
import json

def scrape_medicament_ma():
    """Scrape medication data from medicament.ma"""
    base_url = "https://www.medicament.ma/medicaments/"
    medications = []
    
    response = requests.get(base_url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    for item in soup.select('.medication-item'):
        med = {
            'name': item.select_one('.med-name').text.strip(),
            'price': float(item.select_one('.med-price').text.replace('DH', '').strip()),
            'category': item.select_one('.med-category').text.strip(),
            'dci': item.select_one('.med-dci').text.strip(),
        }
        medications.append(med)
    
    with open('medications_ma.json', 'w', encoding='utf-8') as f:
        json.dump(medications, f, ensure_ascii=False, indent=2)
    
    return medications
```

### Option 2: CSV Import

Prepare a CSV file with the following columns:

```csv
name,name_fr,price,category,category_fr,indications_ar,indications_fr,how_to_use_ar,how_to_use_fr,dosage,prescription_required
Doliprane 1000mg,Doliprane 1000mg,18.50,مسكنات الألم,Antalgiques,...,...,...,...,1000mg,0
```

### Option 3: JSON Import dans l'app

Place a `medications.json` file in `assets/data/` and use this loader:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/medication.dart';

class DataImporter {
  static Future<List<Medication>> importFromJson() async {
    final String jsonString = 
        await rootBundle.loadString('assets/data/medications.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    
    return jsonList.map((json) => Medication(
      name: json['name'],
      nameFr: json['name_fr'],
      price: json['price'].toDouble(),
      category: json['category'],
      categoryFr: json['category_fr'],
      indicationsAr: json['indications_ar'],
      indicationsFr: json['indications_fr'],
      howToUseAr: json['how_to_use_ar'],
      howToUseFr: json['how_to_use_fr'],
      dosage: json['dosage'],
      prescriptionRequired: json['prescription_required'] ?? false,
    )).toList();
  }
}
```

---

## ملاحظات مهمة / Notes Importantes

1. **PPM (Prix Public Maroc)**: الأثمنة خاصها تكون ديال PPM اللي هو الثمن الرسمي المحدد من طرف وزارة الصحة.
   Les prix doivent correspondre au PPM fixé par le Ministère de la Santé.

2. **التحديث / Mise à jour**: الأثمنة كتبدل من وقت لآخر. خاصك تراجع الموقع الرسمي بشكل دوري.
   Les prix changent périodiquement. Vérifiez régulièrement les sources officielles.

3. **حقوق المعطيات / Droits des données**: تأكد أنك كتحترم شروط الاستعمال ديال المواقع اللي كتجمع منها البيانات.
   Assurez-vous de respecter les conditions d'utilisation des sites sources.

4. **الترجمة بالدارجة / Traduction en Darija**: حاول تبسط المعلومات الطبية باش المستعمل المغربي العادي يفهمها.
   Simplifiez les informations médicales pour le grand public marocain.
