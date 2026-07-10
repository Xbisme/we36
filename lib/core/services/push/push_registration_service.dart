import 'dart:async';
import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/services/push/push_service.dart';

/// Registers the device push token with the backend over its lifetime (#013 US2).
/// Subscribes to [PushService.tokenStream] (emits once permission is granted /
/// on launch when already granted), caches the last token, and registers it via
/// the repository (`POST /devices`) — but **only while authenticated**, since
/// `POST /devices` needs a Bearer token. `SessionController` drives [register] on
/// auth and [unregister] on logout. The token is a credential — held only here in
/// memory, never logged. Constructed at boot so it is listening before the first
/// token arrives.
@lazySingleton
class PushRegistrationService {
  PushRegistrationService(this._push, this._repo) {
    _sub = _push.tokenStream.listen(_onToken);
  }

  final PushService _push;
  final NotificationsRepository _repo;

  late final StreamSubscription<String> _sub;
  String? _lastToken;
  bool _authed = false;

  static String get _platform => Platform.isIOS ? 'ios' : 'android';

  Future<void> _onToken(String token) async {
    _lastToken = token;
    // Register immediately only if already signed in; otherwise [register] (called
    // by SessionController once the session token is hydrated) does it — avoids a
    // premature unauthenticated `POST /devices` (401) at cold start.
    if (_authed) await _repo.registerDevice(_platform, token);
  }

  /// Called by `SessionController` once authenticated (session token hydrated) —
  /// registers the cached token with a valid Bearer. Idempotent (`POST /devices`
  /// upserts).
  Future<void> register() async {
    _authed = true;
    final token = _lastToken;
    if (token != null) await _repo.registerDevice(_platform, token);
  }

  /// Unregister the current device token (logout / account switch). Idempotent.
  Future<void> unregister() async {
    _authed = false;
    final token = _lastToken;
    if (token == null) return;
    _lastToken = null;
    await _repo.unregisterDevice(token);
  }

  /// Tear down (retiring the singleton / tests).
  Future<void> dispose() async => _sub.cancel();
}
