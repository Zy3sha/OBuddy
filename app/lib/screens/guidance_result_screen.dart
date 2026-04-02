import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/result_card.dart';
import '../widgets/badge_chip.dart';
import '../models/guidance_response.dart';

/// Displays the full Blended Response Model output for a behaviour.
/// Shown after tapping a Quick Help category.
class GuidanceResultScreen extends StatelessWidget {
  final GuidanceResponse response;
  final VoidCallback? onBack;
  final VoidCallback? onSave;

  const GuidanceResultScreen({
    super.key,
    required this.response,
    this.onBack,
    this.onSave,
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
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.subtleShadow,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BadgeChip(
                    label: response.behaviourType.toUpperCase().replaceAll('_', ' '),
                    color: AppColors.accentRose,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Title
              Text(
                "Here's how to\nhandle it",
                style: AppTextStyles.display,
              ),
              const SizedBox(height: 4),
              Text(
                'Calm, connected, and consistent.',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // The 3-part result card
              ResultCard(response: response),
              const SizedBox(height: AppTheme.spacingLg),

              // Save button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                    label: const Text('Save to Library'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySage,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                      ),
                      textStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                      elevation: 0,
                    ),
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
