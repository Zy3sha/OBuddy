import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core palette ──
  static const background    = Color(0xFFFAF6F0);
  static const card          = Color(0xFFFFF9F2);
  static const cardBorder    = Color(0xFFF0EAE0);
  static const primarySage   = Color(0xFF6FA898);
  static const primaryDark   = Color(0xFF4E8F80);
  static const textMain      = Color(0xFF4A3B35);
  static const textMuted     = Color(0xFF8D8076);
  static const textLight     = Color(0xFFB0A89E);

  // ── Accent palette ──
  static const accentGreen   = Color(0xFFA8C3AA);
  static const accentSand    = Color(0xFFF2EBD5);
  static const accentPeach   = Color(0xFFF5E0D0);
  static const accentBlue    = Color(0xFFB8D4E3);
  static const accentLavender = Color(0xFFD5C8E0);
  static const accentRose    = Color(0xFFE8C4C4);
  static const accentAmber   = Color(0xFFF0D8A8);

  // ── Functional ──
  static const white         = Color(0xFFFFFFFF);
  static const divider       = Color(0xFFE8E2DA);
  static const shimmer       = Color(0x0A000000);

  // ── Icon background tints ──
  static const iconBgSage    = Color(0xFFE0F0EA);
  static const iconBgPeach   = Color(0xFFFCEDE4);
  static const iconBgBlue    = Color(0xFFE2EEF5);
  static const iconBgLavender = Color(0xFFEDE4F2);
  static const iconBgAmber   = Color(0xFFFCF2E0);
  static const iconBgRose    = Color(0xFFF8E8E8);

  // ── Shadows ──
  static List<BoxShadow> get cardShadow => [
    const BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    const BoxShadow(
      color: Color(0x08000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
}
