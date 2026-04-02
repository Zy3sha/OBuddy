import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';
import 'progress_ring.dart';

class PathCard extends StatelessWidget {
  final String icon;
  final String title;
  final String stage;
  final double progress; // 0.0 to 1.0
  final Color? iconBgColor;
  final VoidCallback? onTap;

  const PathCard({
    super.key,
    required this.icon,
    required this.title,
    required this.stage,
    required this.progress,
    this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor ?? AppColors.iconBgSage,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Title + stage
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subheading),
                const SizedBox(height: 2),
                Text(stage, style: AppTextStyles.small),
              ],
            ),
          ),

          // Progress ring
          ProgressRing(
            value: progress,
            size: 44,
            strokeWidth: 3.5,
            child: Text(
              '$pct%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
