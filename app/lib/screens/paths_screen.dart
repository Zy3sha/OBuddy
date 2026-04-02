import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/path_card.dart';
import '../data/path_definitions.dart';
import '../models/path_progress.dart';

class PathsScreen extends StatelessWidget {
  final List<PathProgress> pathProgress;
  final ValueChanged<String>? onPathTap;

  const PathsScreen({
    super.key,
    required this.pathProgress,
    this.onPathTap,
  });

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
            Text('Your Paths', style: AppTextStyles.display),
            const SizedBox(height: 4),
            Text(
              'Small steps. Big growth.',
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFF8D8076),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Path cards
            ...allPaths.map((pathDef) {
              final progress = pathProgress
                  .where((p) => p.pathId == pathDef.id)
                  .firstOrNull;
              final stageIndex = progress?.currentStage ?? 0;
              final stageName = stageIndex < pathDef.stageNames.length
                  ? pathDef.stageNames[stageIndex]
                  : pathDef.stageNames.last;

              return PathCard(
                icon: pathDef.icon,
                title: pathDef.title,
                stage: stageName,
                progress: progress?.progress ?? 0.0,
                iconBgColor: pathDef.iconBgColor,
                onTap: () => onPathTap?.call(pathDef.id),
              );
            }),
          ],
        ),
      ),
    );
  }
}
