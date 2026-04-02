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
import '../data/temperament_system.dart';

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
    final rhythm = child.rhythm;

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
                  Text(child.ageLabel,
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Temperament Profile ──
            if (temperament != null) ...[
              const SectionHeader(title: 'Temperament'),
              _TemperamentCard(temperament: temperament),
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
              const SizedBox(height: AppTheme.spacingMd),

              // What works best
              const SectionHeader(title: 'What works best'),
              _BulletList(
                items: ProfileEngine.getWhatWorks(temperament.primaryType),
                color: AppColors.primarySage,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // What to avoid
              const SectionHeader(title: 'What to avoid'),
              _BulletList(
                items: ProfileEngine.getWhatToAvoid(temperament.primaryType),
                color: AppColors.accentRose,
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],

            // ── Current Rhythm Phase ──
            if (rhythm != null) ...[
              const SectionHeader(title: 'Current Phase'),
              _RhythmCard(rhythm: rhythm),
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

/// Full temperament display card with emoji, type, blend, strength reframe,
/// and daily description.
class _TemperamentCard extends StatelessWidget {
  final TemperamentProfile temperament;
  const _TemperamentCard({required this.temperament});

  @override
  Widget build(BuildContext context) {
    final type = ProfileEngine.getType(temperament.primaryType);
    final emoji = type?.emoji ?? '🌟';
    final label = type?.label ?? temperament.primaryType.replaceAll('-', ' ');
    final strengthLabel = type?.strengthLabel ?? '';
    final daily = type?.dailyLooksLike ?? '';

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary badge
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BadgeChip(
                      label: label,
                      icon: Icons.psychology_rounded,
                      color: AppColors.primarySage,
                    ),
                    if (temperament.secondaryType != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'with ${temperament.secondaryType!.replaceAll('-', ' ')} tendencies',
                        style: AppTextStyles.small
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (strengthLabel.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 14, color: AppColors.primarySage),
                  const SizedBox(width: 6),
                  Text(
                    strengthLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (daily.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              daily,
              style: AppTextStyles.body.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rhythm phase card showing current developmental phase.
class _RhythmCard extends StatelessWidget {
  final RhythmState rhythm;
  const _RhythmCard({required this.rhythm});

  @override
  Widget build(BuildContext context) {
    final phaseEmoji = _phaseEmojis[rhythm.currentPhase] ?? '🫧';
    final phaseLabel = _phaseLabels[rhythm.currentPhase] ??
        rhythm.currentPhase.replaceAll('-', ' ');

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(phaseEmoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              BadgeChip(
                label: phaseLabel,
                color: AppColors.accentLavender,
              ),
              const Spacer(),
              _ConfidenceDot(confidence: rhythm.confidence),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rhythm.explanation,
            style: AppTextStyles.body,
          ),
          if (rhythm.secondaryPhase != null) ...[
            const SizedBox(height: 8),
            Text(
              'Also showing signs of: ${rhythm.secondaryPhase!.replaceAll('-', ' ')}',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  static const _phaseEmojis = {
    'boundary-testing': '🧱',
    'independence-surge': '🚀',
    'sensitivity-wave': '🌊',
    'connection-seeking': '🤗',
    'skill-stretch': '🌱',
    'cooperation-bloom': '🌻',
    'reset-phase': '🫧',
  };

  static const _phaseLabels = {
    'boundary-testing': 'Boundary Testing',
    'independence-surge': 'Independence Surge',
    'sensitivity-wave': 'Sensitivity Wave',
    'connection-seeking': 'Connection Phase',
    'skill-stretch': 'Skill Stretch',
    'cooperation-bloom': 'Cooperation Bloom',
    'reset-phase': 'Reset',
  };
}

class _ConfidenceDot extends StatelessWidget {
  final String confidence;
  const _ConfidenceDot({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final color = confidence == 'high'
        ? AppColors.primarySage
        : confidence == 'medium'
            ? AppColors.accentAmber
            : AppColors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          confidence,
          style: AppTextStyles.label.copyWith(color: color),
        ),
      ],
    );
  }
}

/// Simple bullet list widget.
class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color color;
  const _BulletList({required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(item, style: AppTextStyles.body),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
