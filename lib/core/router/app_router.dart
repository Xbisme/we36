import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/router/adaptive_shell.dart';
import 'package:we36/core/router/auth_guard_stub.dart';
import 'package:we36/core/router/centered_mobile.dart';
import 'package:we36/features/dev/presentation/gallery_page.dart';
import 'package:we36/features/dev/presentation/states_demo_page.dart';
import 'package:we36/features/dev/presentation/two_pane_demo_page.dart';
import 'package:we36/features/explore/presentation/explore_page.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/messaging/presentation/messages_page.dart';
import 'package:we36/features/placeholder_page.dart';
import 'package:we36/features/profile/presentation/profile_page.dart';
import 'package:we36/features/reels/presentation/reels_page.dart';

/// The single app router (Constitution X): auth-guarded split, 5-tab
/// StatefulShellRoute, nav-less flow + pre-auth routes (wrapped centered-mobile
/// on tablet, FR-016). The guard reads [AuthGuardStub] (a stub swapped for the
/// real session in #003).
@lazySingleton
class AppRouter {
  AppRouter(this._guard) {
    router = GoRouter(
      initialLocation: AppRoutes.home,
      refreshListenable: _guard,
      redirect: _redirect,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AdaptiveShell(navigationShell: navigationShell),
          branches: [
            _branch(AppRoutes.home, const HomePage()),
            _branch(AppRoutes.explore, const ExplorePage()),
            _branch(AppRoutes.reels, const ReelsPage()),
            _branch(AppRoutes.messages, const MessagesPage()),
            _branch(AppRoutes.profile, const ProfilePage()),
          ],
        ),
        // Pre-auth zone (nav-less, centered-mobile on tablet)
        _flow(
          AppRoutes.splash,
          const PlaceholderPage(title: 'Splash', showBack: false),
        ),
        _flow(
          AppRoutes.onboarding,
          const PlaceholderPage(title: 'Onboarding', showBack: false),
        ),
        _flow(AppRoutes.signIn, const PlaceholderPage(title: 'Sign in')),
        _flow(AppRoutes.signUp, const PlaceholderPage(title: 'Sign up')),
        _flow(
          AppRoutes.forgotPassword,
          const PlaceholderPage(title: 'Forgot password'),
        ),
        _flow(
          AppRoutes.profileSetup,
          const PlaceholderPage(title: 'Profile setup'),
        ),
        // Flow routes (nav-less)
        _flow(
          AppRoutes.notifications,
          const PlaceholderPage(title: 'Activity'),
        ),
        _flow(AppRoutes.settings, const PlaceholderPage(title: 'Settings')),
        _flow(AppRoutes.create, const PlaceholderPage(title: 'Create')),
        _flow(AppRoutes.search, const PlaceholderPage(title: 'Search')),
        // Dev harness
        _flow(AppRoutes.devGallery, const GalleryPage()),
        _flow(AppRoutes.devStates, const StatesDemoPage()),
        _flow(AppRoutes.devTwoPane, const TwoPaneDemoPage()),
      ],
    );
  }

  final AuthGuardStub _guard;
  late final GoRouter router;

  static final Set<String> _preAuth = {
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.forgotPassword,
    AppRoutes.profileSetup,
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final inPreAuth = _preAuth.contains(loc);
    if (!_guard.isSignedIn && !inPreAuth) return AppRoutes.splash;
    if (_guard.isSignedIn && inPreAuth) return AppRoutes.home;
    return null;
  }

  static StatefulShellBranch _branch(String path, Widget child) {
    return StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (_, _) => child)],
    );
  }

  static GoRoute _flow(String path, Widget child) {
    return GoRoute(
      path: path,
      builder: (_, _) => CenteredMobile(child: child),
    );
  }
}
