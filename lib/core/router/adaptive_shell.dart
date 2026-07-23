import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/presentation/bottom_nav.dart';
import 'package:we36/core/presentation/nav_item.dart';
import 'package:we36/core/presentation/sidebar_rail.dart';
import 'package:we36/core/router/adaptive_layout_mode.dart';
import 'package:we36/core/router/nav_destination.dart';
import 'package:we36/core/services/messaging/messaging_badge.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

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
    // The Messages-tab unread badge streams from the core badge seam (#012,
    // Constitution XI — a core→core read; guarded so a minimal DI still renders).
    final badge = getIt.isRegistered<MessagingBadge>()
        ? getIt<MessagingBadge>()
        : null;
    final notifBadge = getIt.isRegistered<NotificationsBadge>()
        ? getIt<NotificationsBadge>()
        : null;
    return StreamBuilder<int>(
      stream: badge?.unreadConversationCount,
      initialData: 0,
      builder: (context, msgSnap) => StreamBuilder<int>(
        stream: notifBadge?.unreadCount,
        initialData: 0,
        builder: (context, notifSnap) =>
            _buildShell(context, msgSnap.data ?? 0, notifSnap.data ?? 0),
      ),
    );
  }

  Widget _buildShell(BuildContext context, int unread, int notifUnread) {
    final l10n = context.l10n;
    final mode = AdaptiveLayoutMode.fromWidth(MediaQuery.sizeOf(context).width);

    final destItems = [
      for (final d in NavDestination.values)
        NavItemData(
          icon: d.icon,
          label: d.label(l10n),
          badgeCount: d == NavDestination.messages && unread > 0
              ? unread
              : null,
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
      NavItemData(
        icon: AppIcons.notification,
        label: l10n.navNotifications,
        badgeCount: notifUnread > 0 ? notifUnread : null,
      ),
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
            profileActive: _index == NavDestination.profile.index,
            onSelect: (i) {
              if (i < NavDestination.values.length) {
                _goBranch(i);
              } else if (i == NavDestination.values.length) {
                unawaited(context.push(AppRoutes.notifications));
              } else {
                unawaited(context.push(AppRoutes.composePick));
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
          // Static search entry — real search navigation lands in #009.
          AppSearchBar(hint: l10n.navExplore, readOnly: true),
          const Spacer(),
          // Footer links (static in #004). Suggestions arrive with #010.
          Text(
            'About · Help · Privacy · Terms',
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '© We36',
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
          ),
        ],
      ),
    );
  }
}
