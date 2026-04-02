import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/hero_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/section_header.dart';
import '../models/child_profile.dart';
import '../engines/hero_engine.dart';
import '../models/path_progress.dart';

class HomeScreen extends StatelessWidget {
  final ChildProfile child;
  final List<PathProgress> activePaths;
  final VoidCallback? onQuickHelp;
  final VoidCallback? onFoodToday;
  final VoidCallback? onLifeSkills;
  final ValueChanged<String>? onPathTap;

  const HomeScreen({
    super.key,
    required this.child,
    required this.activePaths,
    this.onQuickHelp,
    this.onFoodToday,
    this.onLifeSkills,
    this.onPathTap,
  });

  @override
  Widget build(BuildContext context) {
    final hero = HeroEngine.generate(child: child, activePaths: activePaths);
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppTheme.spacingMd,
          topPadding + AppTheme.spacingMd,
          AppTheme.spacingMd,
          AppTheme.spacingXxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar: child profile ──
            _ChildHeader(child: child),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Hero Card ──
            HeroCard(
              focus: hero.focusIntro,
              focusHighlight: hero.focusHighlight,
              observation: hero.observation,
              context: hero.challenge,
              action: hero.action,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Active Path ──
            if (activePaths.isNotEmpty) ...[
              const SectionHeader(title: 'Your Active Path'),
              _ActivePathCard(
                path: activePaths.first,
                onTap: () => onPathTap?.call(activePaths.first.pathId),
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],

            // ── Quick Actions ──
            const SectionHeader(title: 'Quick Actions'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickActionButton(
                  icon: Icons.favorite_rounded,
                  label: 'Quick Help',
                  bgColor: AppColors.iconBgRose,
                  iconColor: AppColors.accentRose,
                  onTap: onQuickHelp,
                ),
                QuickActionButton(
                  icon: Icons.restaurant_rounded,
                  label: 'Food Today',
                  bgColor: AppColors.iconBgAmber,
                  iconColor: AppColors.accentAmber,
                  onTap: onFoodToday,
                ),
                QuickActionButton(
                  icon: Icons.star_rounded,
                  label: 'Life Skills',
                  bgColor: AppColors.iconBgSage,
                  iconColor: AppColors.primarySage,
                  onTap: onLifeSkills,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }
}

class _ChildHeader extends StatelessWidget {
  final ChildProfile child;
  const _ChildHeader({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accentSand,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
            style: AppTextStyles.heading.copyWith(
              color: AppColors.primaryDark,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  child.name,
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            Text(
              child.ageLabel,
              style: AppTextStyles.small,
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.card,
            shape: BoxShape.circle,
            boxShadow: AppColors.subtleShadow,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 20,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _ActivePathCard extends StatelessWidget {
  final PathProgress path;
  final VoidCallback? onTap;
  const _ActivePathCard({required this.path, this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = (path.progress * 100).round();
    final pathNames = {
      'potty': 'Potty Path',
      'food': 'Food Explorer',
      'feelings': 'Big Feelings',
      'skills': 'Life Skills',
      'routine': 'Routine Path',
    };
    final stageLabels = {
      'potty': 'Getting familiar with the potty',
      'food': 'Expanding food comfort',
      'feelings': 'Learning to name emotions',
      'skills': 'Building independence every day',
      'routine': 'Setting a calm rhythm',
    };

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pathNames[path.pathId] ?? 'Path',
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(height: 4),
                Text(
                  stageLabels[path.pathId] ?? path.todayGoal,
                  style: AppTextStyles.small,
                ),
                const SizedBox(height: 8),
                // Subtle progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: path.progress,
                    backgroundColor: AppColors.primarySage.withOpacity(0.10),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primarySage),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          ProgressRing(
            value: path.progress,
            size: 52,
            strokeWidth: 4,
            child: Text(
              '$pct%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
