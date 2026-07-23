import 'package:flutter/painting.dart';

/// Raw color ramps — referenced ONLY by token definitions (AppColorsX,
/// AppGradients), never at widget call sites (Constitution VI). Values from
/// ui-design-context.md §Design Tokens.
abstract final class AppColors {
  // Brand rose
  static const rose50 = Color(0xFFFFF1F3);
  static const rose300 = Color(0xFFFF94A6);
  static const rose400 = Color(0xFFFF6B82);
  static const rose500 = Color(0xFFFF4E64);
  static const rose600 = Color(0xFFED3853);
  static const rose700 = Color(0xFFC72741);

  // Accent violet
  static const violet500 = Color(0xFF8B5CF6);
  static const violet400 = Color(0xFF9D7BFA);

  // Warm / cool accents
  static const amber400 = Color(0xFFFFB627);
  static const mint400 = Color(0xFF2DD4BF);
  static const mint500 = Color(0xFF16B6A2);

  // Neutral
  static const ink = Color(0xFF1A1A2E); // never pure black
  static const gray500 = Color(0xFF6B7280);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray50 = Color(0xFFF9FAFB);
  static const white = Color(0xFFFFFFFF);

  // Dark surfaces (ink-tinted, never pure black)
  static const darkBg = Color(0xFF0E0E1A);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkSurface2 = Color(0xFF24243C);
  static const darkSunken = Color(0xFF131322);
  static const darkBorder = Color(0xFF2E2E48);
  static const darkBorderStrong = Color(0xFF3D3D5C);

  // Status
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
}
