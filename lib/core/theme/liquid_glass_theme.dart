import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:factshot/app/app_state.dart';

class LiquidGlassTheme {
  static bool get isDark {
    final appState = AppState.instance;
    if (appState != null) {
      if (appState.themeMode == ThemeMode.light) return false;
      if (appState.themeMode == ThemeMode.dark) return true;
    }
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  static Color get background =>
      isDark ? const Color(0xFF05070B) : const Color(0xFFF5F7FA);
  static Color get backgroundSecondary =>
      isDark ? const Color(0xFF0B1018) : const Color(0xFFFFFFFF);
  static Color get backgroundTertiary =>
      isDark ? const Color(0xFF101827) : const Color(0xFFE2E8F0);
  static Color get foreground =>
      isDark ? const Color(0xFFF7FAFF) : const Color(0xFF0F172A);
  static Color get foregroundMuted =>
      isDark ? const Color(0xFFB7C2D3) : const Color(0xFF475569);
  static Color get foregroundSoft =>
      isDark ? const Color(0xFF7E8898) : const Color(0xFF64748B);
  static Color get outline =>
      isDark ? const Color(0x26FFFFFF) : const Color(0x1F000000);
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF67D5A5);

  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;

  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;
  static const double radius28 = 28;
  static const double radius32 = 32;

  static const Duration quick = Duration(milliseconds: 180);
  static const Duration regular = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 420);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve emphasizedDecelerate = Curves.easeOutQuart;
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  static TextStyle get display => GoogleFonts.spaceGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -1.4,
    color: foreground,
  );

  static TextStyle get headline => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.08,
    letterSpacing: -0.8,
    color: foreground,
  );

  static TextStyle get title => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.3,
    color: foreground,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: -0.15,
    color: foregroundMuted,
  );

  static TextStyle get bodyStrong => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: -0.2,
    color: foreground,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.12,
    color: foregroundSoft,
  );

  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: 1.1,
    color: foregroundSoft,
  );

  static ThemeData theme(Color accentColor, bool isDark) {
    final localBackground = isDark ? const Color(0xFF05070B) : const Color(0xFFF5F7FA);
    final localBackgroundSecondary = isDark ? const Color(0xFF0B1018) : const Color(0xFFFFFFFF);
    final localBackgroundTertiary = isDark ? const Color(0xFF101827) : const Color(0xFFE2E8F0);
    final localForeground = isDark ? const Color(0xFFF7FAFF) : const Color(0xFF0F172A);
    final localOutline = isDark ? const Color(0x26FFFFFF) : const Color(0x1F000000);

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: accentColor,
            secondary: accentColor,
            surface: localBackgroundSecondary,
            error: error,
          )
        : ColorScheme.light(
            primary: accentColor,
            secondary: accentColor,
            surface: localBackgroundSecondary,
            error: error,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: localBackground,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: display.copyWith(color: localForeground),
        headlineLarge: headline.copyWith(color: localForeground),
        titleLarge: title.copyWith(color: localForeground),
        bodyLarge: body.copyWith(color: localForeground),
        bodyMedium: body.copyWith(color: localForeground),
        labelMedium: caption.copyWith(color: localForeground),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: localBackgroundTertiary.withValues(alpha: 0.88),
        contentTextStyle: body.copyWith(color: localForeground),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
          side: BorderSide(color: localOutline),
        ),
      ),
      dividerTheme: DividerThemeData(thickness: 1, color: localOutline, space: 1),
    );
  }
}
