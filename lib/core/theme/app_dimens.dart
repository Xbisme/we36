/// Spacing scale (4px base) and radius scale. Use these tokens — never magic
/// numbers at call sites (Constitution VI).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;

  /// Mobile gutter.
  static const double gutter = 16;

  /// Minimum tap target.
  static const double tapTarget = 44;

  /// Centered content max widths on wide layouts.
  static const double feedMaxWidth = 470;
  static const double profileMaxWidth = 900;
  static const double notificationsMaxWidth = 620;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double full = 9999;
}
