import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const double radiusCard = 16.0;
  static const double radiusButton = 12.0;
  static const double radiusPill = 99.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primarySage,
      onPrimary: AppColors.white,
      surface: AppColors.background,
      onSurface: AppColors.textMain,
      secondary: AppColors.accentGreen,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTextStyles.heading,
      iconTheme: IconThemeData(color: AppColors.textMain),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primarySage,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.display,
      headlineMedium: AppTextStyles.heading,
      titleMedium: AppTextStyles.subheading,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.small,
      labelSmall: AppTextStyles.label,
    ),
    dividerColor: AppColors.divider,
    splashColor: AppColors.primarySage.withOpacity(0.08),
    highlightColor: AppColors.primarySage.withOpacity(0.04),
  );
}
