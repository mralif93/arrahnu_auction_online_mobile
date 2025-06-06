import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Montserrat';

  // Font Sizes
  static const double xs = 12.0;   // bodySmall
  static const double sm = 14.0;   // bodyMedium
  static const double base = 16.0; // bodyLarge
  static const double lg = 18.0;   // titleMedium
  static const double xl = 20.0;   // titleLarge
  static const double xl2 = 24.0;  // headlineSmall
  static const double xl3 = 30.0;  // headlineMedium
  static const double xl4 = 36.0;  // headlineLarge

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Body Styles
  static TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: xs,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: base,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );

  // Title Styles
  static TextStyle get titleSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: base,
    fontWeight: medium,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: lg,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: xl,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );

  // Headline Styles
  static TextStyle get headlineSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: xl2,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: xl3,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: xl4,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );

  // Label Styles
  static TextStyle get labelSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: xs,
    fontWeight: medium,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: medium,
    color: AppColors.textSecondary,
  );

  // Button Text Style
  static TextStyle get buttonText => TextStyle(
    fontFamily: fontFamily,
    fontSize: sm,
    fontWeight: semiBold,
    color: AppColors.textWhite,
  );

  // Helper method to modify any style
  static TextStyle modify(TextStyle style, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return style.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }
}
