import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Assembles the fixed light and dark themes. There is NO color-scheme picker
/// (Constitution VI) — only light / dark / follow-system.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light, AppColorsX.light());
  static ThemeData get dark => _build(Brightness.dark, AppColorsX.dark());

  static ThemeData _build(Brightness brightness, AppColorsX tokens) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.rose500,
          brightness: brightness,
        ).copyWith(
          surface: tokens.surface,
          primary: tokens.accent,
          error: tokens.error,
        );

    final textTheme = TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: tokens.textPrimary,
      ),
      headlineLarge: AppTypography.h1.copyWith(color: tokens.textPrimary),
      headlineMedium: AppTypography.h2.copyWith(color: tokens.textPrimary),
      headlineSmall: AppTypography.h3.copyWith(color: tokens.textPrimary),
      titleMedium: AppTypography.label.copyWith(color: tokens.textPrimary),
      bodyLarge: AppTypography.body16.copyWith(color: tokens.textPrimary),
      bodyMedium: AppTypography.body16.copyWith(color: tokens.textSecondary),
      labelLarge: AppTypography.label.copyWith(color: tokens.textPrimary),
      bodySmall: AppTypography.caption.copyWith(color: tokens.textTertiary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.bgApp,
      canvasColor: tokens.bgApp,
      fontFamily: AppTypography.body,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}
