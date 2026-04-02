import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.margin = EdgeInsets.zero,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.card,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
            boxShadow: AppColors.cardShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
