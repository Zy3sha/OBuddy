import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';
import '../models/food_entry.dart';
import '../data/food_data.dart';

class FoodTodayScreen extends StatelessWidget {
  final String safeFood;
  final String newExposure;
  final String approach;
  final Map<ExposureStage, int> exposureCounts;

  const FoodTodayScreen({
    super.key,
    this.safeFood = 'Pasta',
    this.newExposure = 'Broccoli',
    this.approach = 'Place it on the plate, no pressure.',
    this.exposureCounts = const {
      ExposureStage.seen: 3,
      ExposureStage.touched: 1,
      ExposureStage.smelled: 0,
      ExposureStage.tasted: 0,
    },
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            topPadding + AppTheme.spacingSm,
            AppTheme.spacingMd,
            AppTheme.spacingXxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.subtleShadow,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMain),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Header
              Text('Food Explorer', style: AppTextStyles.display),
              const SizedBox(height: 4),
              Text(
                'Today\'s gentle plan',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              ),
              Text(
                'No pressure, just progress.',
                style: AppTextStyles.small.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Safe food
              const SectionHeader(title: 'Safe food'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.primarySage, size: 20),
                    const SizedBox(width: 10),
                    Text(safeFood, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // New exposure
              const SectionHeader(title: 'New exposure'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Row(
                  children: [
                    const Text('🥦', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(newExposure, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Approach
              const SectionHeader(title: 'Your approach'),
              GlassCard(
                color: AppColors.primarySage.withOpacity(0.06),
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Text(
                  approach,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryDark,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Progress tracker
              const SectionHeader(title: 'Today\'s progress'),
              ...exposureCounts.entries.map((entry) {
                final info = exposureStageInfo[entry.key];
                if (info == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(info.icon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(info.label, style: AppTextStyles.bodyMedium),
                        ),
                        Text(
                          '${entry.value} time${entry.value == 1 ? '' : 's'}',
                          style: AppTextStyles.small,
                        ),
                        const SizedBox(width: 8),
                        // Dot indicators (max 5)
                        Row(
                          children: List.generate(5, (i) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < entry.value
                                    ? AppColors.primarySage
                                    : AppColors.primarySage.withOpacity(0.15),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppTheme.spacingMd),

              // Encouragement
              GlassCard(
                color: AppColors.accentSand.withOpacity(0.5),
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Text(
                  'Exposure builds confidence. You\'re doing great.',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primaryDark,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Add note
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text('Add a note'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primarySage,
                    textStyle: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
