import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final Color? color;
  final Color? trackColor;
  final double strokeWidth;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.value,
    this.size = 48,
    this.color,
    this.trackColor,
    this.strokeWidth = 4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              value: value.clamp(0.0, 1.0),
              color: color ?? AppColors.primarySage,
              trackColor: trackColor ?? AppColors.primarySage.withOpacity(0.12),
              strokeWidth: strokeWidth,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (value > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * value,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}
