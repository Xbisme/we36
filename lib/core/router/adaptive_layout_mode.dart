import 'package:we36/core/constants/app_breakpoints.dart';

/// The layout mode derived from window width. Selects the navigation chrome and
/// content constraints (Constitution VI/VII).
enum AdaptiveLayoutMode {
  phone,
  tabletCompact,
  tabletFull,
  tabletWide;

  static AdaptiveLayoutMode fromWidth(double width) {
    if (width < AppBreakpoints.tablet) return AdaptiveLayoutMode.phone;
    if (width < AppBreakpoints.sidebarFull) {
      return AdaptiveLayoutMode.tabletCompact;
    }
    if (width < AppBreakpoints.wide) return AdaptiveLayoutMode.tabletFull;
    return AdaptiveLayoutMode.tabletWide;
  }

  bool get isPhone => this == AdaptiveLayoutMode.phone;
  bool get isTablet => !isPhone;

  /// Rail is icon-only below the full threshold.
  bool get railCompact => this == AdaptiveLayoutMode.tabletCompact;

  /// Home shows the right suggestions rail at the widest breakpoint.
  bool get showRightRail => this == AdaptiveLayoutMode.tabletWide;
}
