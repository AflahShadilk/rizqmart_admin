import 'package:flutter/material.dart';

/// Centralized color palette for RizqMart Admin to ensure unified UI consistency
class AppColors {
  // Primary & Accent Colors
  static const Color primary = Colors.blue;
  static const Color primaryLight = Color(0xFFE3F2FD); // Colors.blue.shade50
  static const Color primaryDark = Color(0xFF1565C0); // Colors.blue.shade800
  static const Color accent = Colors.orange;

  // Backgrounds & Surfaces
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF8F9FA); // Very light grey
  static const Color cardBackground = Colors.white;

  // Texts
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color(0xFF757575); // Colors.grey.shade600
  static const Color textHint = Color(0xFFBDBDBD); // Colors.grey.shade400
  static const Color textLight = Colors.white;

  // Status & Feedback Colors
  static const Color success = Colors.green;
  static const Color successLight = Color(0xFFE8F5E9); // Colors.green.shade50
  static const Color error = Colors.red;
  static const Color errorLight = Color(0xFFFFEBEE); // Colors.red.shade50
  static const Color warning = Colors.orange;
  static const Color warningLight = Color(0xFFFFF3E0); // Colors.orange.shade50
  static const Color info = Colors.blue;

  // Borders & Dividers
  static const Color border = Color(0xFFEEEEEE); // Colors.grey.shade200
  static const Color divider = Color(0xFFE0E0E0); // Colors.grey.shade300

  // Specific UI Elements
  static const Color shadowColor = Colors.black;
  static const Color overlayColor = Colors.black12;

  // Greys (Commonly used in the app)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
}
