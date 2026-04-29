import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../utils/app_colors.dart';

class DetailScreen extends StatelessWidget {
  final Medication medication;
  final bool isArabic;

  const DetailScreen({
    super.key,
    required this.medication,
    required this.isArabic,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'مسكنات الألم':
        return Icons.healing;
      case 'مضادات حيوية':
        return Icons.medication;
      case 'مضادات الالتهاب':
        return Icons.local_fire_department;
      case 'أمراض المعدة':
        return Icons.breakfast_dining;
      case 'أمراض التنفس':
        return Icons.air;
      case 'فيتامينات':
        return Icons.bolt;
      case 'أمراض الجلد':
        return Icons.spa;
      case 'طفيليات':
        return Icons.bug_report;
      default:
        return Icons.medication_liquid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic ? medication.name : medication.nameFr,
            style: const TextStyle(fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildPriceSection(),
              if (medication.isFromOnline) ...[
                _buildOnlineInfoSection(),
                _buildDivider(),
              ],
              if (medication.indicationsAr.isNotEmpty ||
                  medication.indicationsFr.isNotEmpty) ...[
                _buildDivider(),
                _buildSection(
                  icon: Icons.info_outline,
                  title: isArabic ? 'دواعي الاستعمال' : 'Indications',
                  content: isArabic
                      ? medication.indicationsAr
                      : medication.indicationsFr,
                  color: AppColors.lightBlue,
                ),
              ],
              if (medication.howToUseAr.isNotEmpty ||
                  medication.howToUseFr.isNotEmpty) ...[
                _buildDivider(),
                _buildSection(
                  icon: Icons.medical_information,
                  title: isArabic ? 'كيفاش تستعملو' : 'Comment l\'utiliser',
                  content: isArabic
                      ? medication.howToUseAr
                      : medication.howToUseFr,
                  color: AppColors.emeraldGreen,
                ),
              ],
              if (medication.dosage.isNotEmpty) ...[
                _buildDivider(),
                _buildDosageSection(),
              ],
              if (medication.prescriptionRequired) ...[
                _buildDivider(),
                _buildPrescriptionWarning(),
              ],
              _buildDivider(),
              _buildDisclaimerSection(),
              if (medication.isFromOnline) _buildSourceBadge(),
              const SizedBox(height: 16),
              _buildCopyright(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.emeraldGreen,
            AppColors.emeraldGreen.withAlpha(204),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getCategoryIcon(medication.category),
              size: 44,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? medication.name : medication.nameFr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (medication.form != null && medication.form!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              medication.form!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withAlpha(200),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isArabic ? medication.category : medication.categoryFr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
          if (medication.prescriptionRequired) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.prescriptionBadge,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber,
                      size: 16, color: AppColors.white),
                  const SizedBox(width: 4),
                  Text(
                    isArabic ? 'خاصو بوردونونص' : 'Ordonnance requise',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emeraldGreen.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.emeraldGreen.withAlpha(51)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sell, color: AppColors.priceTag, size: 22),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'الثمن: ' : 'Prix: ',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                isArabic ? medication.priceDirham : medication.priceFormatted,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.priceTag,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? '(PPV)' : '(PPV - Prix Public de Vente)',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (medication.priceHospital != null ||
              medication.pricePara != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (medication.priceHospital != null) ...[
                  Text(
                    'PH: ${medication.priceHospital!.toStringAsFixed(2)} DH',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (medication.pricePara != null)
                    const SizedBox(width: 16),
                ],
                if (medication.pricePara != null)
                  Text(
                    'PPC: ${medication.pricePara!.toStringAsFixed(2)} DH',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOnlineInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withAlpha(12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.lightBlue),
              const SizedBox(width: 8),
              Text(
                isArabic
                    ? 'معلومات من medicament.ma'
                    : 'Informations de medicament.ma',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (medication.packaging != null &&
              medication.packaging!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.inventory_2_outlined,
              label: isArabic ? 'التعبئة' : 'Conditionnement',
              value: medication.packaging!,
            ),
          if (medication.manufacturer != null &&
              medication.manufacturer!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.business,
              label: isArabic ? 'المختبر' : 'Laboratoire',
              value: medication.manufacturer!,
            ),
          if (medication.form != null && medication.form!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.science_outlined,
              label: isArabic ? 'الشكل' : 'Forme',
              value: medication.form!,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosageSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.science,
                    color: Color(0xFF9C27B0), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                isArabic ? 'الجرعة' : 'Dosage',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.medication, color: Color(0xFF9C27B0)),
                const SizedBox(width: 10),
                Text(
                  medication.dosage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionWarning() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.prescriptionBadge.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.prescriptionBadge.withAlpha(76)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.prescriptionBadge, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isArabic
                  ? 'هاد الدوا خاصو وصفة طبية (ordonnance). ما تشريهش بلا ما تمشي عند الطبيب.'
                  : 'Ce médicament nécessite une ordonnance. Ne l\'achetez pas sans consultation médicale.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.prescriptionBadge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isArabic
                  ? 'هاد المعلومات غير للتثقيف الصحي. ما تعوضش استشارة الطبيب أو الصيدلي. إلا كنتي شاك، سول الصيدلي ديالك.'
                  : 'Ces informations sont fournies à titre éducatif uniquement et ne remplacent pas l\'avis d\'un médecin ou d\'un pharmacien.',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_outlined, size: 14, color: AppColors.lightBlue),
          const SizedBox(width: 6),
          Text(
            isArabic
                ? 'المصدر: medicament.ma'
                : 'Source: medicament.ma',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          '© Jellouli Said 2026',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.divider,
    );
  }
}
