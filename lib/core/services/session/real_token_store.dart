import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/session/token_store.dart';

/// The real [TokenStore]: access + refresh tokens in platform secure storage
/// (Keychain / Keystore), with an in-memory mirror so the auth interceptor's
/// synchronous [accessToken] read never blocks (Constitution I). Registered
/// env-agnostically — persistence needs no backend, so a session survives
/// restarts in both `fake` and `real` environments (spec FR-008, finding I1).
@LazySingleton(as: TokenStore)
class RealTokenStore implements TokenStore {
  RealTokenStore() : _storage = const FlutterSecureStorage();

  /// Testing seam: inject a mock/fake secure storage.
  @visibleForTesting
  RealTokenStore.withStorage(this._storage);

  static const String _kAccess = 'we36.accessToken';
  static const String _kRefresh = 'we36.refreshToken';

  final FlutterSecureStorage _storage;

  String? _access;
  String? _refresh;

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
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  @override
  Future<void> hydrate() async {
    // Degrade gracefully when the platform channel is unavailable (e.g. host
    // unit tests with no plugin): treat as signed-out rather than crashing.
    try {
      _access = await _storage.read(key: _kAccess);
      _refresh = await _storage.read(key: _kRefresh);
    } on Object {
      _access = null;
      _refresh = null;
    }
  }
}
