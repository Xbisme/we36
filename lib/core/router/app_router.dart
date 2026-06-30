import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/router/adaptive_shell.dart';
import 'package:we36/core/router/centered_mobile.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:we36/features/auth/presentation/splash/splash_page.dart';
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
/// on tablet, FR-016). The redirect is driven by the app-wide
/// [SessionController] (#003): cold-start splash, auth + profile-completion
/// routing, forced sign-out.
@lazySingleton
class AppRouter {
  AppRouter(this._session) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _session,
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
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, _) => const SplashPage(),
        ),
        _flow(
          AppRoutes.onboarding,
          const PlaceholderPage(title: 'Onboarding', showBack: false),
        ),
        _flow(AppRoutes.signIn, const SignInPage()),
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

  final SessionController _session;
  late final GoRouter router;

  /// Routes reachable while signed out (no auth required). Splash is handled
  /// separately (valid only while the session is resolving); `profileSetup` is
  /// auth-required.
  static final Set<String> _preAuth = {
    AppRoutes.onboarding,
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.forgotPassword,
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;

    // Still resolving the session on cold start → hold on Splash.
    if (_session.status == AuthStatus.unknown) {
      return loc == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final signedOutEntry = _session.onboardingSeen
        ? AppRoutes.signIn
        : AppRoutes.onboarding;

    if (!_session.isSignedIn) {
      // Resolved as signed out → leave splash for the entry screen.
      if (loc == AppRoutes.splash) return signedOutEntry;
      if (_preAuth.contains(loc)) return null;
      return signedOutEntry;
    }

    // Signed in but profile not completed → must finish setup.
    if (!_session.profileCompleted) {
      return loc == AppRoutes.profileSetup ? null : AppRoutes.profileSetup;
    }

    // Signed in + completed → keep out of splash / pre-auth flow / setup.
    if (loc == AppRoutes.splash ||
        loc == AppRoutes.profileSetup ||
        _preAuth.contains(loc)) {
      return AppRoutes.home;
    }
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
