/// Centralized REST endpoint paths (Constitution VIII) — never inline literals at
/// call sites. All paths are relative to the per-flavor base URL, which is rooted
/// at `/v1` (see `AppConfig.apiBaseUrl`). Shapes from the backend contract
/// (`backend/.claude/claude-app/api-context.md`).
abstract final class ApiEndpoints {
  /// Auth (#003) — email-first credentials, OAuth, recovery, username check.
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authForgot = '/auth/forgot';
  static const String authReset = '/auth/reset';
  static const String authCheckUsername = '/auth/check-username';

  /// OAuth exchange — `provider` ∈ {google, apple}.
  static String authOauth(String provider) => '/auth/oauth/$provider';

  /// Single-flight refresh target (wired into the refresh interceptor, #002).
  static const String authRefresh = '/auth/refresh';

  /// Current user profile.
  static const String me = '/me';

  /// First-run profile setup.
  static const String meSetup = '/me/setup';

  /// Public profile by handle (reference slice for #002).
  static String userByUsername(String username) => '/users/$username';

  /// Reverse-chronological feed (cursor) — consumed from #004.
  static const String feed = '/feed';

  /// Post engagement (#004) — idempotent like/save toggles returning
  /// `EngagementState`. `POST` adds, `DELETE` removes (both no-ops if already in
  /// the target state, per the B#004 contract).
  static String postLike(String id) => '/posts/$id/like';
  static String postSave(String id) => '/posts/$id/save';

  /// Media upload (#007) — multipart upload of a processed image; returns a
  /// `MediaRef` (id + variants). Idempotent via the client `Idempotency-Key`.
  static const String media = '/media';

  /// Create post (#007) — publishes a post from uploaded media ids + caption +
  /// metadata; idempotent via the client `Idempotency-Key`. B#007 seam.
  static const String posts = '/posts';

  /// Stories (#004) — **provisional**: no backend stories contract exists yet
  /// (backend has auth/posts/media/comments only). The `StoriesRepository` real
  /// seam targets this path but is never exercised while the app runs `fake`;
  /// finalize when a backend stories spec lands.
  static const String stories = '/stories';
}
