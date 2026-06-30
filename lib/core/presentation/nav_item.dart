import 'package:flutter/widgets.dart';

/// A single navigation entry rendered by `BottomNav`/`SidebarRail`. The router
/// maps its `NavDestination`s into these — components stay pure.
class NavItemData {
  const NavItemData({
    required this.icon,
    required this.label,
    this.badgeCount,
  });

  final IconData icon;
  final String label;
  final int? badgeCount;
}
