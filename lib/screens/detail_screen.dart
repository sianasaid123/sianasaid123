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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'مسكنات الألم':
        return const Color(0xFF2196F3);
      case 'مضادات حيوية':
        return const Color(0xFFF44336);
      case 'مضادات الالتهاب':
        return const Color(0xFFFF9800);
      case 'أمراض المعدة':
        return const Color(0xFF9C27B0);
      case 'أمراض التنفس':
        return const Color(0xFF00BCD4);
      case 'فيتامينات':
        return const Color(0xFFFF9800);
      case 'أمراض الجلد':
        return const Color(0xFFE91E63);
      case 'طفيليات':
        return const Color(0xFF795548);
      default:
        return AppColors.emeraldGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(medication.category);

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
              _buildHeader(categoryColor),
              _buildPriceSection(),
              _buildDivider(),
              _buildSection(
                icon: Icons.info_outline,
                title: isArabic ? 'دواعي الاستعمال' : 'Indications',
                content: isArabic
                    ? medication.indicationsAr
                    : medication.indicationsFr,
                color: AppColors.lightBlue,
              ),
              _buildDivider(),
              _buildSection(
                icon: Icons.medical_information,
                title: isArabic ? 'كيفاش تستعملو' : 'Comment l\'utiliser',
                content: isArabic
                    ? medication.howToUseAr
                    : medication.howToUseFr,
                color: AppColors.emeraldGreen,
              ),
              _buildDivider(),
              _buildDosageSection(),
              if (medication.prescriptionRequired) ...[
                _buildDivider(),
                _buildPrescriptionWarning(),
              ],
              _buildDivider(),
              _buildDisclaimerSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color categoryColor) {
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
                  const Icon(Icons.warning_amber, size: 16, color: AppColors.white),
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
      child: Row(
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
            isArabic ? '(PPM)' : '(PPM - Prix Public Maroc)',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
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
                child: const Icon(Icons.science, color: Color(0xFF9C27B0), size: 20),
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
