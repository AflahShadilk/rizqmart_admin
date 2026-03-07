import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

class AppTheme {
  static const Color _primaryLight = AppColors.teal;
  static const Color _primaryDark = AppColors.tealLight;

  static const Color _surfaceLight = AppColors.surfaceLight;
  static const Color _surfaceDark = AppColors.dashboardDark1;

  static const Color _cardLight = AppColors.white;
  static const Color _cardDark = AppColors.cardDark;

  static final Color _scaffoldLight = AppColors.backgroundColor;
  static const Color _scaffoldDark = AppColors.backgroundColorDark;

  static const Color _textPrimaryLight = AppColors.dashboardDark1;
  static final Color _textPrimaryDark = AppColors.backgroundColor;

  static const Color _textSecondaryLight = AppColors.slate;
  static const Color _textSecondaryDark = AppColors.slateLight;

  static final Color _borderLight = AppColors.grey200;
  static const Color _borderDark = AppColors.borderDark;

  static const Color _drawerLight = AppColors.cardDark;
  static const Color _drawerDark = AppColors.dashboardDark1;

  static const Color _appBarLight = AppColors.dashboardDark1;
  static const Color _appBarDark = AppColors.cardDark;

  static const Color success = AppColors.emerald;
  static const Color error = AppColors.chartRed;
  static const Color warning = AppColors.amber;
  static const Color info = AppColors.chartBlue;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryLight,
      scaffoldBackgroundColor: _scaffoldLight,
      colorScheme: ColorScheme.light(
        primary: _primaryLight,
        secondary: AppColors.indigo,
        surface: _surfaceLight,
        error: error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: _textPrimaryLight,
        outline: _borderLight,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textPrimaryLight),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textPrimaryLight),
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimaryLight),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _textPrimaryLight),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimaryLight),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimaryLight),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimaryLight),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textSecondaryLight),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _textPrimaryLight),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textPrimaryLight),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: _textSecondaryLight),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimaryLight),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textSecondaryLight),
          labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _textSecondaryLight),
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _borderLight.withValues(alpha: 0.5)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _appBarLight,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _drawerLight,
        scrimColor: AppColors.black54,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryLight, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: _textSecondaryLight, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          side: const BorderSide(color: _primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _cardLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimaryLight,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _textSecondaryLight,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      dividerTheme: DividerThemeData(
        color: _borderLight,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryLight;
          return AppColors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _cardLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _primaryLight,
        unselectedLabelColor: _textSecondaryLight,
        indicatorColor: _primaryLight,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryDark,
      scaffoldBackgroundColor: _scaffoldDark,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: _primaryDark,
        selectionColor: AppColors.tealLight25,
        selectionHandleColor: _primaryDark,
      ),
      colorScheme: ColorScheme.dark(
        primary: _primaryDark,
        secondary: AppColors.indigoLight,
        surface: _surfaceDark,
        error: AppColors.redLight,
        onPrimary: _scaffoldDark,
        onSecondary: _scaffoldDark,
        onSurface: _textPrimaryDark,
        outline: _borderDark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textPrimaryDark),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textPrimaryDark),
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimaryDark),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _textPrimaryDark),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textPrimaryDark),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimaryDark),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimaryDark),
          titleSmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textSecondaryDark),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _textPrimaryDark),
          bodyMedium:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textPrimaryDark),
          bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: _textSecondaryDark),
          labelLarge:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimaryDark),
          labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textSecondaryDark),
          labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _textSecondaryDark),
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _borderDark.withValues(alpha: 0.5)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _appBarDark,
        foregroundColor: _textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _textPrimaryDark,
        ),
        iconTheme: IconThemeData(color: _textPrimaryDark),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: _drawerDark,
        scrimColor: AppColors.black54,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _borderDark.withValues(alpha: 0.7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _borderDark.withValues(alpha: 0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryDark, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: _textSecondaryDark.withValues(alpha: 0.7), fontSize: 14),
        labelStyle: GoogleFonts.inter(color: _textSecondaryDark, fontSize: 14),
        floatingLabelStyle: GoogleFonts.inter(color: _primaryDark, fontSize: 14, fontWeight: FontWeight.w500),
        errorStyle: GoogleFonts.inter(color: AppColors.redLight, fontSize: 12),
        prefixIconColor: _textSecondaryDark,
        suffixIconColor: _textSecondaryDark,
        iconColor: _textSecondaryDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: _scaffoldDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: const BorderSide(color: _primaryDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimaryDark,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _textSecondaryDark,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      dividerTheme: DividerThemeData(
        color: _borderDark,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryDark;
          return AppColors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: _scaffoldDark,
        elevation: 4,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _primaryDark,
        unselectedLabelColor: _textSecondaryDark,
        indicatorColor: _primaryDark,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}
