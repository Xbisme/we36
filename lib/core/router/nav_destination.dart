import 'package:flutter/widgets.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// The five primary destinations. Notifications and Create are NOT destinations
/// (rail-only / contextual) — see Constitution VI navigation IA.
enum NavDestination {
  home(AppRoutes.home, AppIcons.home),
  explore(AppRoutes.explore, AppIcons.search),
  reels(AppRoutes.reels, AppIcons.reels),
  messages(AppRoutes.messages, AppIcons.messages),
  profile(AppRoutes.profile, AppIcons.profile);

  const NavDestination(this.route, this.icon);

  final String route;
  final IconData icon;

  String label(AppLocalizations l10n) => switch (this) {
    NavDestination.home => l10n.navHome,
    NavDestination.explore => l10n.navExplore,
    NavDestination.reels => l10n.navReels,
    NavDestination.messages => l10n.navMessages,
    NavDestination.profile => l10n.navProfile,
  };
}
