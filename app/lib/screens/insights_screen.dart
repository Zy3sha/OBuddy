import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

/// Journal / Insights screen — gentle weekly summary and pattern awareness.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

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
            Text('Insights', style: AppTextStyles.display),
            const SizedBox(height: 4),
            Text(
              'Patterns and progress, gently.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Weekly summary
            const SectionHeader(title: 'This week'),
            GlassCard(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InsightRow(
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.primarySage,
                    text: 'Potty attempts increased — confidence is building.',
                  ),
                  const SizedBox(height: 12),
                  _InsightRow(
                    icon: Icons.restaurant_rounded,
                    iconColor: AppColors.accentAmber,
                    text: 'Broccoli moved from "seen" to "touched" — progress.',
                  ),
                  const SizedBox(height: 12),
                  _InsightRow(
                    icon: Icons.psychology_rounded,
                    iconColor: AppColors.accentLavender,
                    text: 'Tantrums mostly at transitions — that\'s a pattern worth noting.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Recent activity
            const SectionHeader(title: 'Recent'),
            _ActivityTile(
              emoji: '🚽',
              title: 'Sat on potty after breakfast',
              time: 'Today, 8:15am',
            ),
            _ActivityTile(
              emoji: '🧠',
              title: 'Tantrum at nursery drop-off',
              time: 'Yesterday',
            ),
            _ActivityTile(
              emoji: '🥦',
              title: 'Touched broccoli at dinner',
              time: '2 days ago',
            ),
            _ActivityTile(
              emoji: '🪥',
              title: 'Brushed teeth with help',
              time: '3 days ago',
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Encouragement
            GlassCard(
              color: AppColors.primarySage.withOpacity(0.06),
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Text(
                'Small steps add up. You\'re building something that lasts.',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.primaryDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const _InsightRow({required this.icon, required this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String time;
  const _ActivityTile({required this.emoji, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: 12,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  Text(time, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
