import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../data/skill_data.dart';

class LifeSkillsScreen extends StatelessWidget {
  const LifeSkillsScreen({super.key});

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
              Text('Life Skills Quests', style: AppTextStyles.display),
              const SizedBox(height: 4),
              Text(
                'Little moments, big impact.',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Quest cards
              ...allSkillQuests.map((quest) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.iconBgSage,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(quest.icon, style: const TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: AppTheme.spacingMd),

                        // Title + reward
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(quest.title, style: AppTextStyles.subheading),
                              const SizedBox(height: 2),
                              Text(
                                quest.identityReward,
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.primarySage,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status indicator
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textLight,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
