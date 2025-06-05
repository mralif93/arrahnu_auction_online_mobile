import 'package:flutter/material.dart';

/// Standardized responsive padding system for consistent spacing across all pages
class ResponsivePadding {
  /// Standard mobile padding for all pages
  static const double mobile = 18.0;

  /// Get responsive tablet padding based on screen width
  static double getTabletPadding(double screenWidth) {
    if (screenWidth >= 1194) return 28.0; // 14" tablets
    if (screenWidth >= 1112) return 26.0; // 13" tablets
    if (screenWidth >= 1024) return 24.0; // 12" tablets
    if (screenWidth >= 834) return 22.0; // 11" tablets
    return 20.0; // 10" tablets
  }

  /// Get responsive page padding based on screen size
  static EdgeInsets getPagePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    if (isTablet) {
      return EdgeInsets.all(getTabletPadding(screenWidth));
    } else {
      return const EdgeInsets.all(mobile);
    }
  }

  /// Standard vertical spacing between sections
  static const double sectionSpacing = 16.0;

  /// Standard small vertical spacing
  static const double smallSpacing = 10.0;

  /// Standard large vertical spacing
  static const double largeSpacing = 20.0;

  /// Get responsive section spacing based on screen size
  static double getSectionSpacing(double screenWidth) {
    if (screenWidth >= 1024) return largeSpacing; // 12"+ tablets
    if (screenWidth >= 768) return sectionSpacing; // 10-11" tablets
    return sectionSpacing; // Mobile
  }

  /// Get responsive small spacing based on screen size
  static double getSmallSpacing(double screenWidth) {
    if (screenWidth >= 1024) return 16.0; // 12"+ tablets
    if (screenWidth >= 768) return 14.0; // 10-11" tablets
    return smallSpacing; // Mobile
  }

  /// Standard logo container padding
  static const double logoContainerPadding = 20.0;

  /// Standard logo container margin
  static const EdgeInsets logoContainerMargin = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  /// Get responsive logo container margin for tablets
  static EdgeInsets getLogoContainerMargin(double screenWidth) {
    if (screenWidth >= 1024) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    } else if (screenWidth >= 768) {
      return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
    } else {
      return logoContainerMargin;
    }
  }

  /// Standard form field spacing
  static const double formFieldSpacing = 10.0;

  /// Get responsive form field spacing
  static double getFormFieldSpacing(double screenWidth) {
    if (screenWidth >= 1024) return 16.0; // 12"+ tablets
    if (screenWidth >= 768) return 14.0; // 10-11" tablets
    return formFieldSpacing; // Mobile
  }

  /// Standard content padding for input fields
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: 14.0,
    vertical: 12.0,
  );

  /// Get responsive input content padding
  static EdgeInsets getInputContentPadding(double screenWidth) {
    if (screenWidth >= 1024) {
      return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0);
    } else if (screenWidth >= 768) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
    } else {
      return inputContentPadding;
    }
  }

  /// Check if screen size is tablet
  static bool isTabletSize(double screenWidth) {
    return screenWidth >= 768;
  }

  /// Check if screen size is large tablet (12"+)
  static bool isLargeTablet(double screenWidth) {
    return screenWidth >= 1024;
  }

  /// Get responsive top spacing for pages
  static double getTopSpacing(double screenWidth) {
    if (screenWidth >= 1024) return 16.0; // 12"+ tablets
    if (screenWidth >= 768) return 14.0; // 10-11" tablets
    return 10.0; // Mobile
  }
}
