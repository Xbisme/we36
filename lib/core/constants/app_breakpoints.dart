/// Width thresholds (logical px) driving the adaptive chrome. Evaluated by
/// window width via LayoutBuilder/MediaQuery — never device model — so iPad
/// split-view and rotation reflow correctly (Constitution VII).
abstract final class AppBreakpoints {
  /// Below this → phone (bottom nav); at/above → tablet (sidebar rail).
  static const double tablet = 700;

  /// At/above this → sidebar rail shows labels (full); below → icon-only.
  static const double sidebarFull = 980;

  /// At/above this → Home shows the right "Suggestions" rail.
  static const double wide = 1100;
}
