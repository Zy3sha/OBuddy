import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../models/guidance_response.dart';
import 'glass_card.dart';

/// Displays the 3-part Blended Response Model:
/// Calm Boundary → Emotional Validation → Guided Action
class ResultCard extends StatelessWidget {
  final GuidanceResponse response;

  const ResultCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Why this is happening
        _Section(
          icon: Icons.lightbulb_outline_rounded,
          iconColor: AppColors.accentAmber,
          label: 'Why this is happening',
          content: response.whyHappening,
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // What to say (combines boundary + validation)
        _Section(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: AppColors.primarySage,
          label: 'What to say',
          content: '"${response.sampleScript}"',
          isQuote: true,
          sublabel: 'Calm boundary + validation',
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // What to do (guided action)
        _Section(
          icon: Icons.arrow_forward_rounded,
          iconColor: AppColors.accentGreen,
          label: 'What to do',
          content: response.guidedAction,
        ),
        const SizedBox(height: AppTheme.spacingLg),

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
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'You stayed calm. You\'re teaching them more than you know.',
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
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String content;
  final String? sublabel;
  final bool isQuote;

  const _Section({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.content,
    this.sublabel,
    this.isQuote = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              )),
            ],
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(sublabel!, style: AppTextStyles.caption),
            ),
          ],
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              content,
              style: isQuote
                  ? AppTextStyles.body.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryDark,
                    )
                  : AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
