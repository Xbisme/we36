import 'package:injectable/injectable.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/services/realtime/notifications_realtime_service.dart';
import 'package:we36/core/services/session/token_store.dart';

/// Owns the single realtime socket lifecycle (#012, Constitution VIII) — the
/// first live consumer of the #002 scaffold. Driven by `SessionController`:
/// [connect] on session-authenticated, [disconnect] on logout. Reconnect/backoff/
/// heartbeat are Socket.IO built-ins in the client; this only maps session →
/// connect/disconnect and re-attaches the (possibly refreshed) token. Depends on
/// [MessagingRealtimeService] so the sole inbound subscriber is constructed and
/// listening before the first event arrives.
@lazySingleton
class RealtimeConnectionManager {
  RealtimeConnectionManager(
    this._client,
    this._tokenStore,
    this._messaging,
    this._notifications,
  );

  final RealtimeClient _client;
  final TokenStore _tokenStore;
  // Held only to force construction (each subscribes to inbound events on build).
  // ignore: unused_field
  final MessagingRealtimeService _messaging;
  // Held only to force construction (subscribes to `notification.new` on build).
  // ignore: unused_field
  final NotificationsRealtimeService _notifications;

  /// The connection lifecycle stream for the quiet offline/connecting affordance.
  Stream<RealtimeConnectionState> get connectionState =>
      _client.connectionState;

  /// The latest connection state.
  RealtimeConnectionState get state => _client.state;

  /// Connect (or reconnect) using the current access token. No-op with no token.
  void connect() {
    final token = _tokenStore.accessToken;
    if (token == null) return;
    _client.connect(token);
  }

  /// Disconnect intentionally (logout) — no auto-reconnect.
  Future<void> disconnect() => _client.disconnect();
}
