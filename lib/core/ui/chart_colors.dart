import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////
/// PREMIUM SAAS CHART COLOR SYSTEM
/// Inspired by Stripe, Linear, Vercel dashboards
////////////////////////////////////////////////////////////

class ChartColors {
  ChartColors._();

  ////////////////////////////////////////////////////////////
  /// PRIMARY PALETTE
  ////////////////////////////////////////////////////////////

  static const List<Color> palette = [
    Color(0xFF2563EB), // Blue (Primary)
    Color(0xFF16A34A), // Green (Success)
    Color(0xFFEA580C), // Orange (Warning)
    Color(0xFFDC2626), // Red (Error)
    Color(0xFF7C3AED), // Violet
    Color(0xFF0891B2), // Cyan
    Color(0xFFDB2777), // Pink
    Color(0xFF65A30D), // Lime
  ];

  ////////////////////////////////////////////////////////////
  /// GET COLOR BY INDEX
  ////////////////////////////////////////////////////////////

  static Color get(int index) {
    return palette[index % palette.length];
  }

  ////////////////////////////////////////////////////////////
  /// SEMANTIC COLORS
  ////////////////////////////////////////////////////////////

  static const Color primary = Color(0xFF2563EB);

  static const Color success = Color(0xFF16A34A);

  static const Color warning = Color(0xFFEA580C);

  static const Color error = Color(0xFFDC2626);

  static const Color violet = Color(0xFF7C3AED);

  static const Color cyan = Color(0xFF0891B2);

  ////////////////////////////////////////////////////////////
  /// GRADIENTS (FOR PREMIUM EFFECTS)
  ////////////////////////////////////////////////////////////

  static LinearGradient gradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(.35), color.withOpacity(.05)],
    );
  }
}
