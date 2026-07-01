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
  static const String storyViewer = '/story';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String create = '/create';
  static const String search = '/search';

  // Create Post — compose flow (#007), nav-less full-screen (Screens 11–13).
  static const String composePick = '/create/pick';
  static const String composeEdit = '/create/edit';
  static const String composeCaption = '/create/caption';

  // Create Story — compose flow (#005), nav-less full-screen (Screen 9).
  static const String storyComposePick = '/create/story/pick';
  static const String storyCompose = '/create/story';

  // Dev harness (dev flavor only)
  static const String devGallery = '/dev/gallery';
  static const String devStates = '/dev/states';
  static const String devTwoPane = '/dev/two-pane';
}
