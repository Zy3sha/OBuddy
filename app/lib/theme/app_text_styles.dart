import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display — Hero card title ──
  static const display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textMain,
  );

  // ── Heading — Section titles ──
  static const heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
    color: AppColors.textMain,
  );

  // ── Subheading ──
  static const subheading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textMain,
  );

  // ── Body — Main text ──
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMain,
  );

  // ── Body medium ──
  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textMain,
  );

  // ── Small — Labels, captions ──
  static const small = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textMuted,
  );

  // ── Caption — Tiny text ──
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textLight,
  );

  // ── Label — Uppercase section labels ──
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.4,
    color: AppColors.textMuted,
  );
}
