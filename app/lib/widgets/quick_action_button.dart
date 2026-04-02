import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.bgColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 88,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bgColor ?? AppColors.iconBgSage,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.subtleShadow,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 28,
                color: iconColor ?? AppColors.primarySage,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
