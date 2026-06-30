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
}
