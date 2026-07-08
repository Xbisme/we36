import 'dart:async';
import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/services/push/push_service.dart';

/// Registers the device push token with the backend over its lifetime (#013 US2).
/// Subscribes to [PushService.tokenStream] (which only emits once permission is
/// granted), registers/refreshes each token via the repository (`POST /devices`),
/// and remembers the last token so [unregister] (called on logout by
/// `SessionController`) can `DELETE /devices/:token`. The token is a credential —
/// held only here in memory, never logged. Constructed at boot so it is listening
/// before the first token arrives.
@lazySingleton
class PushRegistrationService {
  PushRegistrationService(this._push, this._repo) {
    _sub = _push.tokenStream.listen(_onToken);
  }

  final PushService _push;
  final NotificationsRepository _repo;

  late final StreamSubscription<String> _sub;
  String? _lastToken;

  static String get _platform => Platform.isIOS ? 'ios' : 'android';

  Future<void> _onToken(String token) async {
    _lastToken = token;
    await _repo.registerDevice(_platform, token);
  }

  /// Unregister the current device token (logout / account switch). Idempotent.
  Future<void> unregister() async {
    final token = _lastToken;
    if (token == null) return;
    _lastToken = null;
    await _repo.unregisterDevice(token);
  }

  /// Tear down (retiring the singleton / tests).
  Future<void> dispose() async => _sub.cancel();
}
