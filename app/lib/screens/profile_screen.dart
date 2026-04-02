import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/badge_chip.dart';
import '../widgets/section_header.dart';
import '../widgets/progress_ring.dart';
import '../models/child_profile.dart';
import '../models/path_progress.dart';
import '../engines/profile_engine.dart';
import '../data/path_definitions.dart';

class ProfileScreen extends StatelessWidget {
  final ChildProfile child;
  final List<PathProgress> pathProgress;

  const ProfileScreen({
    super.key,
    required this.child,
    required this.pathProgress,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final temperament = child.temperament;

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
            // ── Child header ──
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accentSand,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(child.name, style: AppTextStyles.display),
                  const SizedBox(height: 4),
                  Text(child.ageLabel, style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Temperament ──
            if (temperament != null) ...[
              const SectionHeader(title: 'Temperament'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BadgeChip(
                      label: temperament.primaryType.replaceAll('-', ' '),
                      icon: Icons.psychology_rounded,
                      color: AppColors.primarySage,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ProfileEngine.describeTemperament(temperament.primaryType),
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Strengths
              const SectionHeader(title: 'Strengths'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProfileEngine.getStrengths(temperament.primaryType)
                    .map((s) => BadgeChip(
                          label: s,
                          color: AppColors.accentGreen,
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],

            // ── Path Progress ──
            const SectionHeader(title: 'Path Progress'),
            ...pathProgress.map((pp) {
              final def = findPath(pp.pathId);
              if (def == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(def.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(def.title, style: AppTextStyles.bodyMedium),
                      ),
                      ProgressRing(
                        value: pp.progress,
                        size: 36,
                        strokeWidth: 3,
                        child: Text(
                          '${(pp.progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Settings link ──
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: const Text('Settings'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textMuted,
                  textStyle: AppTextStyles.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
