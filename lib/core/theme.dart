import 'package:flutter/material.dart';

/// Serene Devotion Design System — translated from the Stitch project
/// Primary: Golden Brown (#815119), Background: Parchment (#FFF8F4)
/// Font: Plus Jakarta Sans
class AppTheme {
  AppTheme._();

  // ── Color Palette ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF815119);
  static const Color primaryContainer = Color(0xFF9D6A30);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);

  static const Color secondary = Color(0xFF695D46);
  static const Color secondaryContainer = Color(0xFFEFDEC0);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF6D614A);

  static const Color tertiary = Color(0xFF625C4A);
  static const Color tertiaryContainer = Color(0xFF7B7461);
  static const Color onTertiary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFF8F4);
  static const Color surface = Color(0xFFFFF8F4);
  static const Color surfaceDim = Color(0xFFEAD7C5);
  static const Color surfaceContainer = Color(0xFFFEEBD8);
  static const Color surfaceContainerHigh = Color(0xFFF8E5D3);
  static const Color surfaceContainerHighest = Color(0xFFF2DFCD);
  static const Color surfaceContainerLow = Color(0xFFFFF1E6);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  static const Color onBackground = Color(0xFF231A0F);
  static const Color onSurface = Color(0xFF231A0F);
  static const Color onSurfaceVariant = Color(0xFF514539);

  static const Color outline = Color(0xFF837468);
  static const Color outlineVariant = Color(0xFFD5C3B5);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color inverseSurface = Color(0xFF392E22);
  static const Color inverseOnSurface = Color(0xFFFFEEDE);
  static const Color inversePrimary = Color(0xFFFABA78);

  // ── Shadows ────────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFFB57E42).withOpacity(0.08),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: const Color(0xFFB57E42).withOpacity(0.14),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Border Radius ──────────────────────────────────────────────────────────
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 9999.0;

  // ── Spacing ────────────────────────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double pageMargin = 24.0;

  // ── Typography ─────────────────────────────────────────────────────────────
  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    color: onSurface,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: onSurface,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.44,
    color: onSurface,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: onSurface,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.29,
    color: onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: onSurface,
  );

  // ── Material Theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: Color(0xFFFFDCBD),
          onPrimaryContainer: Color(0xFF2C1600),
          secondary: secondary,
          onSecondary: onSecondary,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          tertiary: tertiary,
          onTertiary: onTertiary,
          error: error,
          onError: onError,
          surface: surface,
          onSurface: onSurface,
          surfaceContainerHighest: surfaceContainerHighest,
          outline: outline,
          outlineVariant: outlineVariant,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: onSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg),
            ),
            textStyle: labelLg,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusLg),
            ),
            textStyle: labelLg,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: bodyMd.copyWith(color: onSurfaceVariant),
          hintStyle: bodyMd.copyWith(color: outline),
        ),
        cardTheme: CardThemeData(
          color: surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          margin: EdgeInsets.zero,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surfaceContainerLowest,
          selectedItemColor: primary,
          unselectedItemColor: outline,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
          ),
        ),
      );
}
