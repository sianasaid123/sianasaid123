import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../utils/app_colors.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final bool isArabic;
  final VoidCallback onTap;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.isArabic,
    required this.onTap,
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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(medication.category),
                  size: 32,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isArabic ? medication.name : medication.nameFr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (medication.prescriptionRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.prescriptionBadge.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isArabic ? 'بوردونونص' : 'Ordonnance',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.prescriptionBadge,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isArabic
                                ? medication.category
                                : medication.categoryFr,
                            style: TextStyle(
                              fontSize: 12,
                              color: categoryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (medication.isFromOnline)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'medicament.ma',
                              style: TextStyle(
                                fontSize: 8,
                                color: AppColors.lightBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitleText(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isArabic ? medication.priceDirham : medication.priceFormatted,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.priceTag,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitleText() {
    if (medication.isFromOnline) {
      final parts = <String>[];
      if (medication.form != null && medication.form!.isNotEmpty) {
        parts.add(medication.form!);
      }
      if (medication.manufacturer != null &&
          medication.manufacturer!.isNotEmpty) {
        parts.add(medication.manufacturer!);
      }
      return parts.isNotEmpty ? parts.join(' - ') : medication.categoryFr;
    }
    return isArabic ? medication.indicationsAr : medication.indicationsFr;
  }
}
