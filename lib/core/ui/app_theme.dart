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
    /// CUSTOM SURFACE HIERARCHY (CRITICAL FOR PREMIUM LOOK)
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
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF020617),

      surfaceContainerHigh: brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF020617),

      outlineVariant: brightness == Brightness.light
          ? const Color(0xFFE2E8F0)
          : const Color(0xFF334155),
    );

    ////////////////////////////////////////////////////////////
    /// TEXT THEME
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
      /// BACKGROUND LAYERING (MOST IMPORTANT)
      ////////////////////////////////////////////////////////////
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,

      canvasColor: scheme.surfaceContainerLowest,

      dividerColor: scheme.outlineVariant,

      ////////////////////////////////////////////////////////////
      /// TEXT
      ////////////////////////////////////////////////////////////
      textTheme: textTheme,

      ////////////////////////////////////////////////////////////
      /// APP BAR
      ////////////////////////////////////////////////////////////
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: scheme.onSurface,
      ),

      ////////////////////////////////////////////////////////////
      /// CARD (PREMIUM STYLE)
      ////////////////////////////////////////////////////////////
      cardTheme: CardThemeData(
        elevation: 0,

        color: scheme.surface,

        surfaceTintColor: Colors.transparent,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),

          side: BorderSide(color: scheme.outlineVariant.withOpacity(.6)),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// CHIP THEME (FOR PILLS)
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
      /// BUTTON THEME
      ////////////////////////////////////////////////////////////
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: scheme.primary,

          foregroundColor: scheme.onPrimary,

          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// INPUT THEME
      ////////////////////////////////////////////////////////////
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: scheme.surfaceContainerLow,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),

      ////////////////////////////////////////////////////////////
      /// DRAWER
      ////////////////////////////////////////////////////////////
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
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
      /// ICON THEME
      ////////////////////////////////////////////////////////////
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
    );
  }
}
