import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../data/scenarios.dart';

class QuickHelpScreen extends StatelessWidget {
  final ValueChanged<String>? onCategoryTap;

  const QuickHelpScreen({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppTheme.spacingMd,
          topPadding + AppTheme.spacingLg,
          AppTheme.spacingMd,
          AppTheme.spacingXxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's happening\nright now?", style: AppTextStyles.display),
            const SizedBox(height: 4),
            Text(
              'You choose, we\'ll guide.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Category grid
            _CategoryGrid(onCategoryTap: onCategoryTap),
            const SizedBox(height: AppTheme.spacingXl),

            // Encouragement
            GlassCard(
              color: AppColors.primarySage.withOpacity(0.06),
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 18,
                    color: AppColors.primarySage.withOpacity(0.5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You\'re doing better than you think. We\'re here.',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primaryDark,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final ValueChanged<String>? onCategoryTap;
  const _CategoryGrid({this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final iconBgColors = [
      AppColors.iconBgRose,
      AppColors.iconBgAmber,
      AppColors.iconBgPeach,
      AppColors.iconBgLavender,
      AppColors.iconBgBlue,
      AppColors.iconBgSage,
      AppColors.iconBgAmber,
    ];

    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingSm,
      children: List.generate(quickHelpCategories.length, (i) {
        final cat = quickHelpCategories[i];
        return _CategoryTile(
          icon: cat['icon'] as String,
          label: cat['label'] as String,
          bgColor: iconBgColors[i % iconBgColors.length],
          onTap: () => onCategoryTap?.call(cat['type'] as String),
        );
      }),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String icon;
  final String label;
  final Color bgColor;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48 - 16) / 2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppColors.subtleShadow,
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMain,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
