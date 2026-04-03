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
    final typeDef = temperament != null ? ProfileEngine.getType(temperament.primaryType) : null;
    final secondaryDef = temperament?.secondaryType != null
        ? ProfileEngine.getType(temperament!.secondaryType!)
        : null;

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
                      style: AppTextStyles.display.copyWith(color: AppColors.primaryDark),
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

            // ── Temperament profile ──
            if (typeDef != null) ...[
              const SectionHeader(title: 'Temperament'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(typeDef.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BadgeChip(label: typeDef.label, icon: Icons.psychology_rounded, color: AppColors.primarySage),
                              if (secondaryDef != null) ...[
                                const SizedBox(height: 4),
                                Text('with ${secondaryDef.label.toLowerCase()} tendencies', style: AppTextStyles.small.copyWith(color: AppColors.textMuted)),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primarySage.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.primarySage),
                          const SizedBox(width: 8),
                          Text(typeDef.strengthLabel, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primarySage)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(typeDef.description, style: AppTextStyles.body),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Strengths
              const SectionHeader(title: 'Strengths'),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: typeDef.strengths.map((s) => BadgeChip(label: s, color: AppColors.accentGreen)).toList(),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // What works & avoid
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What works best', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    ...typeDef.whatWorksBest.map((w) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('✓ ', style: TextStyle(color: AppColors.primarySage, fontSize: 13)),
                        Expanded(child: Text(w, style: AppTextStyles.small)),
                      ]),
                    )),
                    const Divider(height: 20),
                    Text('What to avoid', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    ...typeDef.whatToAvoid.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('✕ ', style: TextStyle(color: Colors.red.shade300, fontSize: 13)),
                        Expanded(child: Text(a, style: AppTextStyles.small)),
                      ]),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Daily
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What this looks like daily', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Text(typeDef.dailyLooksLike, style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ] else ...[
              // No temperament — quiz nudge
              const SectionHeader(title: 'Temperament'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(children: [
                  const Text('🧩', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text('Discover ${child.name}\'s temperament', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('A 90-second quiz that unlocks personalised guidance.', style: AppTextStyles.small.copyWith(color: AppColors.textMuted), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarySage, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Take the quiz'),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],

            // ── Rhythm phase ──
            if (child.rhythm != null) ...[
              const SectionHeader(title: 'Current Phase'),
              GlassCard(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BadgeChip(label: child.rhythm!.currentPhase.replaceAll('-', ' '), icon: Icons.timeline_rounded, color: AppColors.primarySage),
                    const SizedBox(height: 8),
                    Text(child.rhythm!.explanation, style: AppTextStyles.body),
                    const SizedBox(height: 6),
                    BadgeChip(
                      label: '${child.rhythm!.confidence} confidence',
                      color: child.rhythm!.confidence == 'high' ? AppColors.primarySage : AppColors.accentAmber,
                    ),
                  ],
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: 12),
                  child: Row(children: [
                    Text(def.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(def.title, style: AppTextStyles.bodyMedium)),
                    ProgressRing(
                      value: pp.progress, size: 36, strokeWidth: 3,
                      child: Text('${(pp.progress * 100).round()}%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    ),
                  ]),
                ),
              );
            }),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Settings ──
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: const Text('Settings'),
                style: TextButton.styleFrom(foregroundColor: AppColors.textMuted, textStyle: AppTextStyles.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
