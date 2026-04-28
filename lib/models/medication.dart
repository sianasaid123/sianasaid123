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
  });

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
      indicationsAr: map['indications_ar'] as String,
      indicationsFr: map['indications_fr'] as String,
      howToUseAr: map['how_to_use_ar'] as String,
      howToUseFr: map['how_to_use_fr'] as String,
      dosage: map['dosage'] as String,
      prescriptionRequired: map['prescription_required'] == 1,
    );
  }

  String get priceFormatted => '${price.toStringAsFixed(2)} DH';
  String get priceDirham => '${price.toStringAsFixed(2)} درهم';
}
