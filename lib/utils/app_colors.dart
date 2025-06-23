import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFE8000);
  static const Color primaryLight = Color(0xFFFFAB40);
  static const Color primaryDark = Color(0xFFE67300);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);  // black87
  static const Color textSecondary = Color(0xFF757575);  // grey.shade600
  static const Color textLight = Color(0xFF9E9E9E);  // grey
  static const Color textWhite = Colors.white;

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);  // grey.shade300
  static Color borderLight = Colors.grey.shade200;
  static Color borderFocused = primary;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);  // green
  static const Color error = Color(0xFFE53935);    // red
  static const Color warning = Color(0xFFFFA726);  // orange
  static const Color info = Color(0xFF2196F3);     // blue

  // Utility Colors
  static Color shadowColor = Colors.black.withValues(alpha: 0.1);
  static Color overlayColor = Colors.black.withValues(alpha: 0.5);

  // Container Colors
  static Color containerBorder = primary.withValues(alpha: 0.2);
  static const Color containerShadow = Color(0xFFE0E0E0);

  // Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
