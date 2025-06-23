import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  // Container Styles
  static BoxDecoration get containerDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.containerBorder,
      width: 1,
    ),
    boxShadow: [defaultShadow],
  );

  static BoxDecoration get highlightedContainerDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primary.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [defaultShadow],
  );

  // Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
    boxShadow: [defaultShadow],
  );

  // Input Field Styles
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: defaultInputBorder,
    enabledBorder: defaultInputBorder,
    focusedBorder: focusedInputBorder,
    errorBorder: errorInputBorder,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textWhite,
    textStyle: AppTypography.buttonText,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.primary,
    textStyle: AppTypography.buttonText.copyWith(color: AppColors.primary),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: BorderSide(color: AppColors.primary),
  );

  // Common Border Radius
  static BorderRadius get smallRadius => BorderRadius.circular(8);
  static BorderRadius get mediumRadius => BorderRadius.circular(12);
  static BorderRadius get largeRadius => BorderRadius.circular(16);

  // Common Shadows
  static BoxShadow get defaultShadow => BoxShadow(
    color: AppColors.shadowColor,
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  // Input Borders
  static OutlineInputBorder get defaultInputBorder => OutlineInputBorder(
    borderRadius: smallRadius,
    borderSide: BorderSide(color: AppColors.border),
  );

  static OutlineInputBorder get focusedInputBorder => OutlineInputBorder(
    borderRadius: smallRadius,
    borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
  );

  static OutlineInputBorder get errorInputBorder => OutlineInputBorder(
    borderRadius: smallRadius,
    borderSide: BorderSide(color: AppColors.error),
  );

  // Status Indicators
  static BoxDecoration get successIndicator => BoxDecoration(
    color: AppColors.success.withValues(alpha: 0.1),
    borderRadius: smallRadius,
    border: Border.all(color: AppColors.success),
  );

  static BoxDecoration get errorIndicator => BoxDecoration(
    color: AppColors.error.withValues(alpha: 0.1),
    borderRadius: smallRadius,
    border: Border.all(color: AppColors.error),
  );

  static BoxDecoration get warningIndicator => BoxDecoration(
    color: AppColors.warning.withValues(alpha: 0.1),
    borderRadius: smallRadius,
    border: Border.all(color: AppColors.warning),
  );

  // Helper Methods
  static EdgeInsets getPadding({
    double horizontal = 16,
    double vertical = 16,
  }) => EdgeInsets.symmetric(
    horizontal: horizontal,
    vertical: vertical,
  );

  static BorderRadius getRadius(double radius) => BorderRadius.circular(radius);
}
