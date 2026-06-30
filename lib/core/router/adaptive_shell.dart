import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/bottom_nav.dart';
import 'package:we36/core/presentation/nav_item.dart';
import 'package:we36/core/presentation/sidebar_rail.dart';
import 'package:we36/core/router/adaptive_layout_mode.dart';
import 'package:we36/core/router/nav_destination.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Mock unread count for the Messages badge (#001 has no data layer).
const int _mockUnread = 3;

/// One adaptive shell around the 5-tab StatefulShellRoute. Width `<700` →
/// bottom nav; `≥700` → sidebar rail (compact `<980` / full); `≥1100` → Home
/// adds a right suggestions rail. Same nav model, width-only adaptation
/// (Constitution VI/VII).
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  int get _index => navigationShell.currentIndex;

  void _goBranch(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == _index,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = AdaptiveLayoutMode.fromWidth(MediaQuery.sizeOf(context).width);

    final destItems = [
      for (final d in NavDestination.values)
        NavItemData(
          icon: d.icon,
          label: d.label(l10n),
          badgeCount: d == NavDestination.messages ? _mockUnread : null,
        ),
    ];

    if (mode.isPhone) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNav(
          items: destItems,
          currentIndex: _index,
          onSelect: _goBranch,
        ),
      );
    }

    // Tablet: rail + content (+ optional right rail on Home).
    final railItems = [
      ...destItems,
      NavItemData(icon: AppIcons.notification, label: l10n.navNotifications),
      NavItemData(icon: AppIcons.plus, label: l10n.navCreate),
    ];

    final showRightRail =
        mode.showRightRail && _index == NavDestination.home.index;

    return Scaffold(
      body: Row(
        children: [
          SidebarRail(
            items: railItems,
            currentIndex: _index,
            compact: mode.railCompact,
            profileName: 'you',
            onSelect: (i) {
              if (i < NavDestination.values.length) {
                _goBranch(i);
              } else if (i == NavDestination.values.length) {
                unawaited(context.push(AppRoutes.notifications));
              } else {
                unawaited(context.push(AppRoutes.create));
              }
            },
          ),
          Expanded(child: navigationShell),
          if (showRightRail) const _RightRail(),
        ],
      ),
    );
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Container(
      width: 340,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: tokens.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.suggestionsTitle,
            style: AppTypography.label.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '· · ·',
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
          ),
        ],
      ),
    );
  }
}
