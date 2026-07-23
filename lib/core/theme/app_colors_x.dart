import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors.dart';

/// Semantic color tokens carried through light/dark via [ThemeExtension].
/// Widgets read these via `context.tokens` — NEVER hardcode hex (Constitution VI).
@immutable
class AppColorsX extends ThemeExtension<AppColorsX> {
  const AppColorsX({
    required this.bgApp,
    required this.surface,
    required this.surface2,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnBrand,
    required this.accent,
    required this.accentHover,
    required this.accentPress,
    required this.accentSoft,
    required this.icon,
    required this.iconActive,
    required this.overlay,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.online,
    required this.statusActive,
  });

  factory AppColorsX.light() => const AppColorsX(
    bgApp: AppColors.gray50,
    surface: AppColors.white,
    surface2: AppColors.gray100,
    surfaceSunken: AppColors.gray100,
    border: AppColors.gray200,
    borderStrong: AppColors.gray300,
    divider: AppColors.gray100,
    textPrimary: AppColors.ink,
    textSecondary: AppColors.gray500,
    textTertiary: AppColors.gray400,
    textOnBrand: AppColors.white,
    accent: AppColors.rose500,
    accentHover: AppColors.rose600,
    accentPress: AppColors.rose700,
    accentSoft: AppColors.rose50,
    icon: AppColors.gray500,
    iconActive: AppColors.rose500,
    overlay: Color(0x731A1A2E),
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    online: AppColors.mint400,
    statusActive: AppColors.mint500,
  );

  factory AppColorsX.dark() => const AppColorsX(
    bgApp: AppColors.darkBg,
    surface: AppColors.darkSurface,
    surface2: AppColors.darkSurface2,
    surfaceSunken: AppColors.darkSunken,
    border: AppColors.darkBorder,
    borderStrong: AppColors.darkBorderStrong,
    divider: AppColors.darkSurface2,
    textPrimary: AppColors.gray100,
    textSecondary: AppColors.gray400,
    textTertiary: AppColors.gray500,
    textOnBrand: AppColors.white,
    accent: AppColors.rose500,
    accentHover: AppColors.rose400,
    accentPress: AppColors.rose300,
    accentSoft: Color(0x29FF4E64),
    icon: AppColors.gray400,
    iconActive: AppColors.rose400,
    overlay: Color(0x99000000),
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    online: AppColors.mint400,
    statusActive: AppColors.mint500,
  );

  final Color bgApp;
  final Color surface;
  final Color surface2;
  final Color surfaceSunken;
  final Color border;
  final Color borderStrong;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnBrand;
  final Color accent;
  final Color accentHover;
  final Color accentPress;
  final Color accentSoft;
  final Color icon;
  final Color iconActive;
  final Color overlay;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  /// Presence dot (mint-400) — distinct from [success] green.
  final Color online;

  /// "Active now" / typing status text (mint-500).
  final Color statusActive;

  @override
  AppColorsX copyWith({
    Color? bgApp,
    Color? surface,
    Color? surface2,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnBrand,
    Color? accent,
    Color? accentHover,
    Color? accentPress,
    Color? accentSoft,
    Color? icon,
    Color? iconActive,
    Color? overlay,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? online,
    Color? statusActive,
  }) {
    return AppColorsX(
      bgApp: bgApp ?? this.bgApp,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentPress: accentPress ?? this.accentPress,
      accentSoft: accentSoft ?? this.accentSoft,
      icon: icon ?? this.icon,
      iconActive: iconActive ?? this.iconActive,
      overlay: overlay ?? this.overlay,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      online: online ?? this.online,
      statusActive: statusActive ?? this.statusActive,
    );
  }

  @override
  AppColorsX lerp(ThemeExtension<AppColorsX>? other, double t) {
    if (other is! AppColorsX) return this;
    return AppColorsX(
      bgApp: Color.lerp(bgApp, other.bgApp, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentPress: Color.lerp(accentPress, other.accentPress, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      iconActive: Color.lerp(iconActive, other.iconActive, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      online: Color.lerp(online, other.online, t)!,
      statusActive: Color.lerp(statusActive, other.statusActive, t)!,
    );
  }
}

/// `context.tokens` — semantic color access (Constitution VI).
extension AppTokensX on BuildContext {
  AppColorsX get tokens => Theme.of(this).extension<AppColorsX>()!;
}
