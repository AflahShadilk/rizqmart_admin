import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  static bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  static bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  static double _scaleFactor(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Base width 375 used by most designers
    double scale = width / 375.0;

    if (isDesktop(context)) {
      // On desktop, we clamp heavily to avoid giant UI
      return scale.clamp(1.0, 1.2); 
    } else if (isTablet(context)) {
       // Tablet allowed slightly more
       return scale.clamp(0.9, 1.1);
    } else {
      // Mobile: prevents shrinking too much or growing too much
      return scale.clamp(0.85, 1.1);
    }
  }

  /// Scales font size safely
  static double scaleFont(BuildContext context, double size) =>
      size * _scaleFactor(context);

  /// Scales spacing/padding safely
  static double scaleSpacing(BuildContext context, double size) =>
      size * _scaleFactor(context);

  /// Scales radius safely
  static double scaleRadius(BuildContext context, double size) =>
      size * _scaleFactor(context);
}
