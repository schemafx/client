import 'package:flutter/material.dart';

/// Responsive breakpoints for the application.
/// These are used to determine when to switch between different layouts.
class ResponsiveBreakpoints {
  /// Small devices (phones in portrait)
  static const double mobile = 480;

  /// Tablet devices (landscape phones, small tablets)
  static const double tablet = 768;

  /// Desktop and large tablets
  static const double desktop = 1200;
}

/// Responsive utilities for handling responsive design.
class ResponsiveUtils {
  /// Determines if the device is mobile based on width
  static bool isMobile(double width) => width < ResponsiveBreakpoints.tablet;

  /// Determines if the device is tablet based on width
  static bool isTablet(double width) =>
      width >= ResponsiveBreakpoints.tablet &&
      width < ResponsiveBreakpoints.desktop;

  /// Determines if the device is desktop based on width
  static bool isDesktop(double width) => width >= ResponsiveBreakpoints.desktop;

  /// Get responsive padding based on screen width
  static EdgeInsets responsivePadding(double width) {
    if (isMobile(width)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(width)) {
      return const EdgeInsets.all(12.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  /// Get responsive icon size based on screen width
  static double responsiveIconSize(double width) {
    if (isMobile(width)) return 20.0;
    if (isTablet(width)) return 24.0;
    return 28.0;
  }

  /// Get responsive font size based on screen width
  static double responsiveFontSize(double width, double baseSize) {
    if (isMobile(width)) return baseSize * 0.9;
    if (isTablet(width)) return baseSize;
    return baseSize * 1.1;
  }

  /// Get responsive spacing between elements based on screen width
  static double responsiveSpacing(double width) {
    if (isMobile(width)) return 8.0;
    if (isTablet(width)) return 12.0;
    return 16.0;
  }

  /// Get responsive panel width for side panels
  static double responsivePanelWidth(double screenWidth) {
    if (isMobile(screenWidth)) return screenWidth;
    if (isTablet(screenWidth)) return screenWidth * 0.4;
    return 300;
  }

  /// Determines if panels should be stacked vertically (mobile)
  /// or displayed side-by-side (desktop)
  static bool shouldStackPanels(double width) => isMobile(width);

  /// Get minimum button size for touch targets (48x48 for mobile, 40x40 for desktop)
  static Size getMinimumTouchTarget(double width) {
    if (isMobile(width)) {
      return const Size(48, 48);
    }
    return const Size(40, 40);
  }

  /// Wraps a widget with a responsive builder
  static Widget buildResponsive(
    BuildContext context,
    Widget Function(BuildContext, double) builder,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(context, constraints.maxWidth),
    );
  }
}

/// Shorthand extension for responsive utilities
extension ResponsiveContext on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is mobile
  bool get isMobile => ResponsiveUtils.isMobile(screenWidth);

  /// Check if device is tablet
  bool get isTablet => ResponsiveUtils.isTablet(screenWidth);

  /// Check if device is desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(screenWidth);

  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      ResponsiveUtils.responsivePadding(screenWidth);

  /// Get responsive spacing
  double get responsiveSpacing =>
      ResponsiveUtils.responsiveSpacing(screenWidth);

  /// Should stack panels
  bool get shouldStackPanels => ResponsiveUtils.shouldStackPanels(screenWidth);
}
