import '../models/medication.dart';

class SeedData {
  static List<Medication> getMedications() {
    return [
      Medication(
        id: 1,
        name: 'Doliprane 1000mg',
        nameFr: 'Doliprane 1000mg',
        price: 18.50,
        category: 'مسكنات الألم',
        categoryFr: 'Antalgiques',
        indicationsAr:
            'كيتستعمل باش يسكن الصداع، وجع الراس، الحمى (السخانة)، ووجع العضلات. مزيان حتى للبرد والگريب.',
        indicationsFr:
            'Utilisé pour soulager les maux de tête, la fièvre, les douleurs musculaires et les symptômes du rhume et de la grippe.',
        howToUseAr:
            'خود قرص واحد (1000mg) مع الما. تقدر تعاود بعد 6 ساعات. ما تفوتش 4 أقراص فالنهار.',
        howToUseFr:
            'Prendre 1 comprimé (1000mg) avec de l\'eau. Renouveler si nécessaire après 6 heures. Ne pas dépasser 4 comprimés par jour.',
        dosage: '1000mg',
      ),
      Medication(
        id: 2,
        name: 'Doliprane 500mg',
        nameFr: 'Doliprane 500mg',
        price: 12.00,
        category: 'مسكنات الألم',
        categoryFr: 'Antalgiques',
        indicationsAr:
            'كيسكن الوجع الخفيف والمتوسط: صداع، وجع السنان، الحمى. مناسب للكبار والدراري اللي فوق 27 كيلو.',
        indicationsFr:
            'Soulage les douleurs légères à modérées : maux de tête, douleurs dentaires, fièvre. Convient aux adultes et enfants de plus de 27 kg.',
        howToUseAr:
            'خود قرص واحد أو جوج مرات فالنهار مع الما. ما تزيدش على 6 أقراص فالنهار.',
        howToUseFr:
            'Prendre 1 comprimé, 1 à 2 fois par jour avec de l\'eau. Ne pas dépasser 6 comprimés par jour.',
        dosage: '500mg',
      ),
      Medication(
        id: 3,
        name: 'Augmentin 1g',
        nameFr: 'Augmentin 1g',
        price: 68.50,
        category: 'مضادات حيوية',
        categoryFr: 'Antibiotiques',
        indicationsAr:
            'مضاد حيوي كيعالج البكتيريا: التهابات الحلق، التهابات الأذن، التهابات المسالك البولية، والتهابات الجلد.',
        indicationsFr:
            'Antibiotique utilisé pour traiter les infections bactériennes : angines, otites, infections urinaires et cutanées.',
        howToUseAr:
            'خود قرص واحد مرتين فالنهار (صباح وعشية) مع الماكلة. كمل العلاج كامل حتى لو حسيتي بالتحسن.',
        howToUseFr:
            'Prendre 1 comprimé 2 fois par jour (matin et soir) au cours des repas. Terminer le traitement même en cas d\'amélioration.',
        dosage: '1g/125mg',
        prescriptionRequired: true,
      ),
      Medication(
        id: 4,
        name: 'Amoxicilline 500mg',
        nameFr: 'Amoxicilline 500mg',
        price: 25.00,
        category: 'مضادات حيوية',
        categoryFr: 'Antibiotiques',
        indicationsAr:
            'مضاد حيوي كيعالج الالتهابات البكتيرية ديال الحلق، الأذن، الجيوب الأنفية، والمسالك البولية.',
        indicationsFr:
            'Antibiotique pour le traitement des infections bactériennes de la gorge, des oreilles, des sinus et des voies urinaires.',
        howToUseAr:
            'خود كبسولة وحدة 3 مرات فالنهار (كل 8 ساعات). خاصك تكمل الكور كامل.',
        howToUseFr:
            'Prendre 1 gélule 3 fois par jour (toutes les 8 heures). Compléter le traitement prescrit.',
        dosage: '500mg',
        prescriptionRequired: true,
      ),
      Medication(
        id: 5,
        name: 'Ibuprofen 400mg',
        nameFr: 'Ibuprofène 400mg',
        price: 20.00,
        category: 'مضادات الالتهاب',
        categoryFr: 'Anti-inflammatoires',
        indicationsAr:
            'كيسكن الوجع والالتهاب: وجع الراس، وجع السنان، وجع الظهر، الحمى، ووجع العادة الشهرية.',
        indicationsFr:
            'Soulage la douleur et l\'inflammation : maux de tête, douleurs dentaires, douleurs dorsales, fièvre et douleurs menstruelles.',
        howToUseAr:
            'خود قرص واحد (400mg) بعد الماكلة مع كاس ماء كبير. ما تزيدش على 3 أقراص فالنهار.',
        howToUseFr:
            'Prendre 1 comprimé (400mg) après les repas avec un grand verre d\'eau. Ne pas dépasser 3 comprimés par jour.',
        dosage: '400mg',
      ),
      Medication(
        id: 6,
        name: 'Voltarène 50mg',
        nameFr: 'Voltarène 50mg',
        price: 35.00,
        category: 'مضادات الالتهاب',
        categoryFr: 'Anti-inflammatoires',
        indicationsAr:
            'مضاد للالتهاب كيعالج وجع المفاصل، الروماتيزم، وجع الظهر، وجع العضلات بعد المجهود.',
        indicationsFr:
            'Anti-inflammatoire pour les douleurs articulaires, rhumatismes, douleurs dorsales et douleurs musculaires.',
        howToUseAr:
            'خود قرص واحد مرتين إلى 3 مرات فالنهار مع الماكلة. ما تستعملوش أكثر من أسبوع بلا استشارة الطبيب.',
        howToUseFr:
            'Prendre 1 comprimé 2 à 3 fois par jour au cours des repas. Ne pas utiliser plus d\'une semaine sans avis médical.',
        dosage: '50mg',
        prescriptionRequired: true,
      ),
      Medication(
        id: 7,
        name: 'Oméprazole 20mg',
        nameFr: 'Oméprazole 20mg',
        price: 30.00,
        category: 'أمراض المعدة',
        categoryFr: 'Gastro-entérologie',
        indicationsAr:
            'كيعالج حموضة المعدة، القرحة، والارتجاع المعدي المريئي (الحمرة/الحرقان).',
        indicationsFr:
            'Traite l\'acidité gastrique, les ulcères et le reflux gastro-œsophagien (brûlures d\'estomac).',
        howToUseAr:
            'خود كبسولة وحدة قبل الفطور بـ30 دقيقة. ما تمضغهاش، بلعها كاملة.',
        howToUseFr:
            'Prendre 1 gélule 30 minutes avant le petit-déjeuner. Ne pas croquer, avaler entière.',
        dosage: '20mg',
      ),
      Medication(
        id: 8,
        name: 'Smecta',
        nameFr: 'Smecta',
        price: 28.00,
        category: 'أمراض المعدة',
        categoryFr: 'Gastro-entérologie',
        indicationsAr:
            'كيعالج الإسهال عند الكبار والصغار. كيحمي جدار المعدة والأمعاء.',
        indicationsFr:
            'Traite la diarrhée chez l\'adulte et l\'enfant. Protège la muqueuse gastro-intestinale.',
        howToUseAr:
            'حل كيس واحد فكاس ماء. خود 3 أكياس فالنهار بين الوجبات.',
        howToUseFr:
            'Dissoudre 1 sachet dans un verre d\'eau. Prendre 3 sachets par jour entre les repas.',
        dosage: '3g/sachet',
      ),
      Medication(
        id: 9,
        name: 'Ventoline Spray',
        nameFr: 'Ventoline Spray',
        price: 35.00,
        category: 'أمراض التنفس',
        categoryFr: 'Pneumologie',
        indicationsAr:
            'كيفتح القصبات الهوائية. مخصص لمرضى الربو (لازم) وضيق التنفس.',
        indicationsFr:
            'Bronchodilatateur pour le traitement de l\'asthme et des bronchospasmes.',
        howToUseAr:
            'نفختين من البخاخ وقت الأزمة. تقدر تعاود بعد 4 إلى 6 ساعات إلا لزم الأمر.',
        howToUseFr:
            'Inhaler 2 bouffées lors de la crise. Renouveler si nécessaire après 4 à 6 heures.',
        dosage: '100μg/dose',
        prescriptionRequired: true,
      ),
      Medication(
        id: 10,
        name: 'Vitamine C 1000mg',
        nameFr: 'Vitamine C 1000mg',
        price: 45.00,
        category: 'فيتامينات',
        categoryFr: 'Vitamines',
        indicationsAr:
            'كيقوي المناعة، كيعطي الطاقة، وكيساعد الجسم يقاوم البرد والگريب. مزيان فالشتا.',
        indicationsFr:
            'Renforce l\'immunité, donne de l\'énergie et aide l\'organisme à combattre le rhume et la grippe.',
        howToUseAr:
            'حل قرص فوار واحد فكاس ماء وشربو فالصباح. قرص واحد فالنهار كافي.',
        howToUseFr:
            'Dissoudre 1 comprimé effervescent dans un verre d\'eau le matin. 1 comprimé par jour suffit.',
        dosage: '1000mg',
      ),
      Medication(
        id: 11,
        name: 'Magnésium B6',
        nameFr: 'Magnésium B6',
        price: 55.00,
        category: 'فيتامينات',
        categoryFr: 'Vitamines',
        indicationsAr:
            'كيعالج النقص ديال المغنيسيوم: التعب، التوتر، تشنج العضلات، قلة النوم.',
        indicationsFr:
            'Traite la carence en magnésium : fatigue, stress, crampes musculaires, troubles du sommeil.',
        howToUseAr:
            'خود قرصين فالنهار مع الماكلة (واحد فالصباح وواحد فالعشية).',
        howToUseFr:
            'Prendre 2 comprimés par jour au cours des repas (1 matin, 1 soir).',
        dosage: '48mg Mg / 5mg B6',
      ),
      Medication(
        id: 12,
        name: 'Spasfon',
        nameFr: 'Spasfon',
        price: 22.00,
        category: 'مسكنات الألم',
        categoryFr: 'Antispasmodiques',
        indicationsAr:
            'كيعالج التقلصات ديال المعدة والأمعاء والرحم. مزيان لوجع البطن ووجع العادة الشهرية.',
        indicationsFr:
            'Traite les spasmes de l\'estomac, des intestins et de l\'utérus. Efficace contre les douleurs abdominales et menstruelles.',
        howToUseAr:
            'خود قرص واحد إلى جوج 3 مرات فالنهار. تقدر تاخدو على ريق أو بعد الماكلة.',
        howToUseFr:
            'Prendre 1 à 2 comprimés, 3 fois par jour. Peut être pris à jeun ou au cours des repas.',
        dosage: '80mg',
      ),
      Medication(
        id: 13,
        name: 'Aspégic 1000mg',
        nameFr: 'Aspégic 1000mg',
        price: 15.00,
        category: 'مسكنات الألم',
        categoryFr: 'Antalgiques',
        indicationsAr:
            'كيسكن الوجع والحمى. كيتستعمل حتى كمميع للدم عند بعض مرضى القلب.',
        indicationsFr:
            'Soulage la douleur et la fièvre. Également utilisé comme fluidifiant sanguin chez certains patients cardiaques.',
        howToUseAr:
            'حل كيس واحد فكاس ماء وشربو. ما تفوتش 3 أكياس فالنهار. خودو بعد الماكلة.',
        howToUseFr:
            'Dissoudre 1 sachet dans un verre d\'eau. Ne pas dépasser 3 sachets par jour. Prendre après les repas.',
        dosage: '1000mg',
      ),
      Medication(
        id: 14,
        name: 'Toplexil Sirop',
        nameFr: 'Toplexil Sirop',
        price: 32.00,
        category: 'أمراض التنفس',
        categoryFr: 'Pneumologie',
        indicationsAr:
            'سيرو ضد السعال الناشف (الكحة اليابسة). كيسكن الحلق وكيهدي السعال بالليل.',
        indicationsFr:
            'Sirop contre la toux sèche. Apaise la gorge et calme la toux nocturne.',
        howToUseAr:
            'معلقة كبيرة 3 مرات فالنهار. فالليل قبل النعاس أحسن وقت.',
        howToUseFr:
            'Une cuillère à soupe 3 fois par jour. Le soir avant le coucher est le meilleur moment.',
        dosage: '0.33mg/ml',
      ),
      Medication(
        id: 15,
        name: 'Clamoxyl 1g',
        nameFr: 'Clamoxyl 1g',
        price: 38.00,
        category: 'مضادات حيوية',
        categoryFr: 'Antibiotiques',
        indicationsAr:
            'مضاد حيوي قوي كيعالج التهابات الحلق، الأذن، الرئة، والمسالك البولية.',
        indicationsFr:
            'Antibiotique puissant pour les infections de la gorge, des oreilles, des poumons et des voies urinaires.',
        howToUseAr:
            'خود قرص واحد مرتين فالنهار (كل 12 ساعة) مع الما. كمل العلاج كامل.',
        howToUseFr:
            'Prendre 1 comprimé 2 fois par jour (toutes les 12 heures) avec de l\'eau. Compléter le traitement.',
        dosage: '1g',
        prescriptionRequired: true,
      ),
      Medication(
        id: 16,
        name: 'Maalox',
        nameFr: 'Maalox',
        price: 25.00,
        category: 'أمراض المعدة',
        categoryFr: 'Gastro-entérologie',
        indicationsAr:
            'كيعالج الحموضة وحرقان المعدة. كيهدي المعدة بسرعة.',
        indicationsFr:
            'Traite l\'acidité et les brûlures d\'estomac. Soulagement rapide.',
        howToUseAr:
            'مضوغ قرص واحد أو جوج بعد الماكلة أو وقت الحرقان.',
        howToUseFr:
            'Croquer 1 à 2 comprimés après les repas ou en cas de brûlures.',
        dosage: '400mg/400mg',
      ),
      Medication(
        id: 17,
        name: 'Fer + Acide Folique',
        nameFr: 'Fer + Acide Folique',
        price: 40.00,
        category: 'فيتامينات',
        categoryFr: 'Vitamines',
        indicationsAr:
            'كيعالج فقر الدم (لانيمي). مهم بزاف للحوامل والنساء اللي عندهم نقص الحديد.',
        indicationsFr:
            'Traite l\'anémie ferriprive. Essentiel pour les femmes enceintes et les personnes carencées en fer.',
        howToUseAr:
            'خود قرص واحد فالنهار على ريق مع كاس عصير البرتقال (باش يتمتص مزيان).',
        howToUseFr:
            'Prendre 1 comprimé par jour à jeun avec un jus d\'orange (pour une meilleure absorption).',
        dosage: '100mg Fe / 0.35mg AF',
      ),
      Medication(
        id: 18,
        name: 'Dermatop Crème',
        nameFr: 'Dermatop Crème',
        price: 48.00,
        category: 'أمراض الجلد',
        categoryFr: 'Dermatologie',
        indicationsAr:
            'كريم كيعالج الحساسية، الحكة، الأكزيما، والتهابات الجلد.',
        indicationsFr:
            'Crème pour le traitement des allergies cutanées, démangeaisons, eczéma et dermatites.',
        howToUseAr:
            'دهن طبقة رقيقة على البلاصة المصابة مرة وحدة إلى مرتين فالنهار. ما تستعملوش أكثر من أسبوعين.',
        howToUseFr:
            'Appliquer une fine couche sur la zone affectée 1 à 2 fois par jour. Ne pas utiliser plus de 2 semaines.',
        dosage: '0.25%',
        prescriptionRequired: true,
      ),
      Medication(
        id: 19,
        name: 'Maxilase',
        nameFr: 'Maxilase',
        price: 30.00,
        category: 'أمراض التنفس',
        categoryFr: 'ORL',
        indicationsAr:
            'كيعالج التهاب الحلق والتورم. كينقص الانتفاخ والوجع فالحنجرة.',
        indicationsFr:
            'Traite les maux de gorge et l\'inflammation. Réduit le gonflement et la douleur pharyngée.',
        howToUseAr:
            'خود قرص واحد 3 مرات فالنهار بعد الماكلة. بلعو كامل مع الما.',
        howToUseFr:
            'Prendre 1 comprimé 3 fois par jour après les repas. Avaler entier avec de l\'eau.',
        dosage: '3000 UI',
      ),
      Medication(
        id: 20,
        name: 'Vermox 100mg',
        nameFr: 'Vermox 100mg',
        price: 15.00,
        category: 'طفيليات',
        categoryFr: 'Antiparasitaires',
        indicationsAr:
            'كيقتل الديدان المعوية (الدود فالكرش). مناسب للكبار والصغار.',
        indicationsFr:
            'Vermifuge pour le traitement des parasites intestinaux. Convient aux adultes et aux enfants.',
        howToUseAr:
            'خود قرص واحد مرة وحدة. عاود نفس الجرعة بعد أسبوعين.',
        howToUseFr:
            'Prendre 1 comprimé en prise unique. Renouveler la même dose après 2 semaines.',
        dosage: '100mg',
      ),
    ];
  }
}
