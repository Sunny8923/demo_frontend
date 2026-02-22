import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light(Color seedColor) {
    return _buildTheme(seedColor, Brightness.light);
  }

  static ThemeData dark(Color seedColor) {
    return _buildTheme(seedColor, Brightness.dark);
  }

  ////////////////////////////////////////////////////////////
  /// MAIN BUILDER
  ////////////////////////////////////////////////////////////

  static ThemeData _buildTheme(Color seedColor, Brightness brightness) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    ////////////////////////////////////////////////////////////
    /// PREMIUM SURFACE SYSTEM (PROPER DEPTH)
    ////////////////////////////////////////////////////////////

    final scheme = baseScheme.copyWith(
      surface: brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF0F172A),

      surfaceContainerLowest: brightness == Brightness.light
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF020617),

      surfaceContainerLow: brightness == Brightness.light
          ? const Color(0xFFF1F5F9)
          : const Color(0xFF020617),

      surfaceContainer: brightness == Brightness.light
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF020617),

      surfaceContainerHigh: brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF020617),

      outlineVariant: brightness == Brightness.light
          ? const Color(0xFFE2E8F0)
          : const Color(0xFF334155),
    );

    ////////////////////////////////////////////////////////////
    /// TEXT THEME (INTER FONT — MODERN STANDARD)
    ////////////////////////////////////////////////////////////

    final textTheme = GoogleFonts.interTextTheme()
        .copyWith(
          titleLarge: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    ////////////////////////////////////////////////////////////
    /// FINAL THEME
    ////////////////////////////////////////////////////////////

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,

      ////////////////////////////////////////////////////////////
      /// BACKGROUND SYSTEM
      ////////////////////////////////////////////////////////////
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      canvasColor: scheme.surfaceContainerLowest,
      dividerColor: scheme.outlineVariant,

      ////////////////////////////////////////////////////////////
      /// INTERACTIONS (MODERN FEEL)
      ////////////////////////////////////////////////////////////
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: scheme.primary.withOpacity(.04),

      ////////////////////////////////////////////////////////////
      /// PAGE TRANSITIONS
      ////////////////////////////////////////////////////////////
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      ////////////////////////////////////////////////////////////
      /// TEXT
      ////////////////////////////////////////////////////////////
      textTheme: textTheme,

      ////////////////////////////////////////////////////////////
      /// APP BAR
      ////////////////////////////////////////////////////////////
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: scheme.onSurface,
      ),

      ////////////////////////////////////////////////////////////
      /// PREMIUM CARD
      ////////////////////////////////////////////////////////////
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: scheme.outlineVariant.withOpacity(.5),
            width: 1,
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// CHIP
      ////////////////////////////////////////////////////////////
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primary,
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),

      ////////////////////////////////////////////////////////////
      /// BUTTON
      ////////////////////////////////////////////////////////////
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// INPUT
      ////////////////////////////////////////////////////////////
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// DRAWER
      ////////////////////////////////////////////////////////////
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// LIST TILE
      ////////////////////////////////////////////////////////////
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      ),

      ////////////////////////////////////////////////////////////
      /// ICONS
      ////////////////////////////////////////////////////////////
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
    );
  }
}
