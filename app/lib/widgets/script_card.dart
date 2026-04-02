import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ScriptCard extends StatelessWidget {
  final String label;
  final String script;

  const ScriptCard({
    super.key,
    required this.label,
    required this.script,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(color: AppColors.primarySage),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.primarySage.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              '"$script"',
              style: AppTextStyles.body.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
