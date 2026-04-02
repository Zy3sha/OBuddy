import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class HeroCard extends StatelessWidget {
  final String focus;
  final String focusHighlight;
  final String observation;
  final String context;
  final String action;
  final VoidCallback? onSave;

  const HeroCard({
    super.key,
    required this.focus,
    required this.focusHighlight,
    required this.observation,
    required this.context,
    required this.action,
    this.onSave,
  });

  @override
  Widget build(BuildContext ctx) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'TODAY\'S FOCUS',
            style: AppTextStyles.label.copyWith(
              color: AppColors.primarySage,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Main focus line
          RichText(
            text: TextSpan(
              style: AppTextStyles.display,
              children: [
                TextSpan(text: '$focus '),
                TextSpan(
                  text: focusHighlight,
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const TextSpan(text: ' 🌱'),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Observation
          Text(
            observation,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppTheme.spacingXs),

          // Context
          Text(
            context,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Action row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySage.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Try this',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      action,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (onSave != null)
                GestureDetector(
                  onTap: onSave,
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.primarySage.withOpacity(0.6),
                    size: 24,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
