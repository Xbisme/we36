/// Centralized REST endpoint paths (Constitution VIII) — never inline literals at
/// call sites. All paths are relative to the per-flavor base URL, which is rooted
/// at `/v1` (see `AppConfig.apiBaseUrl`). Shapes from the backend contract
/// (`backend/.claude/claude-app/api-context.md`).
abstract final class ApiEndpoints {
  /// Auth — single-flight refresh target (#003 wires the credential flow).
  static const String authRefresh = '/auth/refresh';

  /// Current user.
  static const String me = '/me';

  /// Public profile by handle (reference slice for #002).
  static String userByUsername(String username) => '/users/$username';

  /// Reverse-chronological feed (cursor) — consumed from #004.
  static const String feed = '/feed';
}
