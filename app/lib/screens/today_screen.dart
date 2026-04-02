import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../models/today_item.dart';

/// The Family Brain — shared daily organiser.
/// Reduces mental load and partner miscommunication.
class TodayScreen extends StatelessWidget {
  final List<TodayItem> items;
  final String? smartNudge;

  const TodayScreen({
    super.key,
    required this.items,
    this.smartNudge,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final morningItems = items.where((i) => i.period == TodayPeriod.morning).toList();
    final afternoonItems = items.where((i) => i.period == TodayPeriod.afternoon).toList();
    final eveningItems = items.where((i) => i.period == TodayPeriod.evening).toList();

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
            // Header
            Text('Today', style: AppTextStyles.display),
            const SizedBox(height: 4),
            Text(
              'Your family brain. Less to carry.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Smart nudge
            if (smartNudge != null) ...[
              _SmartNudge(text: smartNudge!),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Morning
            if (morningItems.isNotEmpty) ...[
              _PeriodSection(label: 'Morning', icon: '☀️', items: morningItems),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Afternoon
            if (afternoonItems.isNotEmpty) ...[
              _PeriodSection(label: 'Afternoon', icon: '🌤️', items: afternoonItems),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Evening
            if (eveningItems.isNotEmpty) ...[
              _PeriodSection(label: 'Evening', icon: '🌙', items: eveningItems),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Add item button
            const SizedBox(height: AppTheme.spacingSm),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add to today'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primarySage,
                  textStyle: AppTextStyles.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }
}

class _SmartNudge extends StatelessWidget {
  final String text;
  const _SmartNudge({required this.text});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppColors.primarySage.withOpacity(0.06),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primarySage.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: AppColors.primarySage,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.small.copyWith(
                color: AppColors.primaryDark,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSection extends StatelessWidget {
  final String label;
  final String icon;
  final List<TodayItem> items;

  const _PeriodSection({
    required this.label,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.label,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        ...items.map((item) => _TodayItemTile(item: item)),
      ],
    );
  }
}

class _TodayItemTile extends StatelessWidget {
  final TodayItem item;
  const _TodayItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: 12,
      ),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: item.isCompleted
                    ? AppColors.primarySage
                    : AppColors.textLight,
                width: 1.5,
              ),
              color: item.isCompleted
                  ? AppColors.primarySage.withOpacity(0.15)
                  : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: item.isCompleted
                ? const Icon(Icons.check_rounded, size: 14, color: AppColors.primaryDark)
                : null,
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: item.isCompleted
                        ? AppColors.textLight
                        : AppColors.textMain,
                  ),
                ),
                if (item.nudge != null)
                  Text(
                    item.nudge!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primarySage,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          // Time + owner
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.time != null)
                Text(item.time!, style: AppTextStyles.small),
              if (item.assignedTo != null)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentSand,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    item.assignedTo!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
