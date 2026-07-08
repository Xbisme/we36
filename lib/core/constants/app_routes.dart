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

  // Post detail + comments (#006), nav-less full-screen (Screens 14–15).
  static const String postDetail = '/post/:id';

  /// Build the concrete post-detail path for [postId].
  static String postDetailPath(String postId) => '/post/$postId';

  // Explore & Search (#009), nav-less full-screen (Screens 17–19). `search` is
  // declared above. Hashtag/place pages are deep-linkable pushed routes.
  static const String hashtag = '/hashtags/:tag';
  static const String place = '/places/:id';

  /// Build the concrete hashtag-page path for [tag] (lowercase, no `#`).
  static String hashtagPath(String tag) => '/hashtags/$tag';

  /// Build the concrete place-page path for [placeId].
  static String placePath(String placeId) => '/places/$placeId';

  // Profile & Follow (#010). The Profile tab (`profile`, declared above) is my
  // own profile; other users + connections + edit are nav-less pushed routes
  // (Screens 21–23).
  static const String userProfile = '/user/:username';
  static const String userConnections = '/user/:username/connections';
  static const String editProfile = '/profile/edit';

  /// Build the concrete other-user profile path for [username].
  static String userProfilePath(String username) => '/user/$username';

  /// Build the followers/following path for [username] (`tab` = followers|following).
  static String userConnectionsPath(
    String username, {
    String tab = 'followers',
  }) => '/user/$username/connections?tab=$tab';

  // Saved Collections (#011), nav-less full-screen (Screen 24). The Saved tab on
  // my own profile renders the collections grid; opening a collection (or the
  // "All saved" view, `id`='all') pushes this route showing its item grid.
  static const String collection = '/collections/:id';

  /// Build the collection-detail path for [id] (`'all'` = the All-saved view).
  static String collectionPath(String id) => '/collections/$id';

  // Create Post — compose flow (#007), nav-less full-screen (Screens 11–13).
  static const String composePick = '/create/pick';
  static const String composeEdit = '/create/edit';
  static const String composeCaption = '/create/caption';

  // Create Story — compose flow (#005), nav-less full-screen (Screen 9).
  static const String storyComposePick = '/create/story/pick';
  static const String storyCompose = '/create/story';

  // Create Reel — compose flow (#008), nav-less full-screen (contextual Create).
  static const String reelCompose = '/create/reel';

  // Direct Messages (#012), Screens 25–28. The Messages tab (`messages`, declared
  // above) shows the conversation list; a conversation opens as a nav-less pushed
  // thread on phone (a swapped detail pane on tablet — same route/state). New
  // message is a pushed compose route. NOTE: register `newMessage` BEFORE
  // `messageThread` in the router so `/messages/new` is not captured by `:id`.
  static const String newMessage = '/messages/new';
  static const String messageThread = '/messages/:id';

  /// Build the chat-thread path for [conversationId] (deep-linkable `we36://`).
  static String messageThreadPath(String conversationId) =>
      '/messages/$conversationId';

  // Dev harness (dev flavor only)
  static const String devGallery = '/dev/gallery';
  static const String devStates = '/dev/states';
  static const String devTwoPane = '/dev/two-pane';
}
