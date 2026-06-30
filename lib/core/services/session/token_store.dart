import 'package:flutter/foundation.dart';

/// The session credential store (Constitution I/VIII). The auth interceptor reads
/// [accessToken] synchronously on every request; the session layer (#003) reads
/// [refreshToken] and persists/clears the pair. The real implementation
/// (`RealTokenStore`) is backed by `flutter_secure_storage` and is registered
/// env-agnostically (persistence needs no backend), so a session survives app
/// restarts in both the `fake` and `real` environments.
abstract interface class TokenStore {
  /// The current access token, or null when signed out (sync — interceptor seam).
  String? get accessToken;

  /// The current refresh token, or null when signed out.
  String? get refreshToken;

  /// Persist a freshly issued / rotated credential pair.
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  });

  /// Erase both tokens (sign-out / forced re-login).
  Future<void> clear();

  /// Load persisted tokens into the in-memory mirror at app start.
  Future<void> hydrate();
}

/// Test-only in-memory [TokenStore] (no DI registration — replaced in the graph
/// by `RealTokenStore`). Construct directly in unit/bloc tests to script the
/// signed-in/out state without touching platform secure storage.
@visibleForTesting
class FakeTokenStore implements TokenStore {
  String? _access;
  String? _refresh;

  /// Back-compat seed hook (#002 tests): assign to set the access token.
  // ignore: avoid_setters_without_getters
  set current(String? value) => _access = value;

  @override
  String? get accessToken => _access;

  @override
  String? get refreshToken => _refresh;

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _access = accessToken;
    _refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }

  @override
  Future<void> hydrate() async {}
}
