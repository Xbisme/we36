/// Centralized route paths (Constitution X) — never hardcode path strings at
/// call sites. Pre-auth and flow routes are top-level (nav-less); the five
/// destinations are branches of the StatefulShellRoute.
abstract final class AppRoutes {
  // Pre-auth zone (no nav chrome)
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String profileSetup = '/profile-setup';

  // Main app — 5 destinations (branch roots)
  static const String home = '/home';
  static const String explore = '/explore';
  static const String reels = '/reels';
  static const String messages = '/messages';
  static const String profile = '/profile';

  // Flow / full-screen routes (nav-less, placeholders this spec)
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String create = '/create';
  static const String search = '/search';

  // Dev harness (dev flavor only)
  static const String devGallery = '/dev/gallery';
  static const String devStates = '/dev/states';
  static const String devTwoPane = '/dev/two-pane';
}
