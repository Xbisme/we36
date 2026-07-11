import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/utils/app_logger.dart';

/// One realtime connection behind a typed surface (Constitution VIII). Scaffold
/// only in #002 (no feature subscriptions); wired by #012 (DM) / #013
/// (notifications). Reconnect + backoff + heartbeat are Socket.IO built-ins.
abstract interface class RealtimeClient {
  /// Connection lifecycle stream (broadcast).
  Stream<RealtimeConnectionState> get connectionState;

  /// Typed inbound events (broadcast).
  Stream<InboundEvent> get events;

  /// The latest connection state.
  RealtimeConnectionState get state;

  /// Connect, authenticating with [accessToken] on the handshake.
  void connect(String accessToken);

  /// Send a typed outbound event.
  void send(OutboundEvent event);

  /// Disconnect intentionally (no auto-reconnect).
  Future<void> disconnect();
}

/// Socket.IO implementation (matches the backend Socket.IO gateway). Registered
/// only in the `real` environment; #002 tests use `FakeRealtimeClient`.
@LazySingleton(as: RealtimeClient, env: ['real'])
class SocketIoRealtimeClient implements RealtimeClient {
  SocketIoRealtimeClient(this._config, this._logger);

  final AppConfig _config;
  final AppLogger _logger;

  final StreamController<RealtimeConnectionState> _stateController =
      StreamController<RealtimeConnectionState>.broadcast();
  final StreamController<InboundEvent> _eventController =
      StreamController<InboundEvent>.broadcast();

  io.Socket? _socket;
  RealtimeConnectionState _state = const RtDisconnected();

  /// A guarded zone that owns the whole socket lifecycle. Both the connect-time
  /// engine and the teardown run inside it, so a benign transport-close error
  /// thrown from socket_io_client's own timers/microtasks (connect OR destroy
  /// triggered) is routed to [_onSocketZoneError] instead of escaping uncaught.
  late final Zone _socketZone = Zone.current.fork(
    specification: ZoneSpecification(
      handleUncaughtError: (self, parent, zone, error, stackTrace) =>
          _onSocketZoneError(error, stackTrace),
    ),
  );

  @override
  Stream<RealtimeConnectionState> get connectionState =>
      _stateController.stream;

  @override
  Stream<InboundEvent> get events => _eventController.stream;

  @override
  RealtimeConnectionState get state => _state;

  void _setState(RealtimeConnectionState next) {
    _state = next;
    if (!_stateController.isClosed) _stateController.add(next);
  }

  @override
  void connect(String accessToken) {
    _setState(const RtConnecting());
    // socket_io_client can surface a `WebSocketConnectionClosed` from its own
    // reconnect/destroy path when the underlying `web_socket` is already closed
    // (a socket_io_client × web_socket rough edge). That error is thrown on a
    // microtask forked from the socket's engine, so it escapes as an *uncaught*
    // zone error rather than something a try/catch here could catch. Own the
    // socket lifecycle in a guarded zone and degrade quietly on a transport
    // close instead of crashing the app (Constitution VIII: realtime drops are
    // surfaced quietly; the app stays usable read-only).
    _socketZone.run(() {
      final socket =
          io.io(
              _config.realtimeUrl,
              io.OptionBuilder()
                  .setTransports(['websocket'])
                  .disableAutoConnect()
                  .setAuth({'token': accessToken})
                  .build(),
            )
            ..onConnect((_) => _setState(const RtConnected()))
            ..onReconnectAttempt((_) => _setState(const RtReconnecting()))
            ..onDisconnect((_) => _setState(const RtReconnecting()))
            ..onConnectError(
              (e) => _logger.warn('Realtime connect error', data: {'e': '$e'}),
            )
            ..onAny(
              (event, data) => _eventController.add(
                InboundEvent.parse(event, _asMap(data)),
              ),
            );
      _socket = socket..connect();
    });
  }

  /// Terminal error handler for the socket's guarded zone. A benign transport
  /// close is logged quietly (and the state reflects a reconnect); anything
  /// unexpected is logged as an error but never crashes the app.
  void _onSocketZoneError(Object error, StackTrace stackTrace) {
    if (isBenignRealtimeDisconnect(error)) {
      _logger.warn('Realtime transport closed', data: {'reason': '$error'});
      if (_state is RtConnected || _state is RtConnecting) {
        _setState(const RtReconnecting());
      }
      return;
    }
    _logger.error('Realtime error', error: error, stackTrace: stackTrace);
  }

  @override
  void send(OutboundEvent event) => _socket?.emit(event.name, event.data);

  @override
  Future<void> disconnect() async {
    _socketZone.run(_disposeSocket);
    _setState(const RtDisconnected());
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map ? data.cast<String, dynamic>() : const {};

  /// Dispose the socket, swallowing the same benign transport-close error
  /// socket_io_client may throw synchronously from `dispose()`.
  void _disposeSocket() {
    try {
      _socket?.dispose();
    } on Object catch (error) {
      if (!isBenignRealtimeDisconnect(error)) rethrow;
      _logger.warn('Realtime dispose (already closed)', data: {'e': '$error'});
    }
    _socket = null;
  }

  /// Tear down the socket + controllers (call when retiring the singleton).
  Future<void> dispose() async {
    _socketZone.run(_disposeSocket);
    await _stateController.close();
    await _eventController.close();
  }
}

/// Whether [error] is a benign realtime transport close — i.e. the socket (or
/// the server) dropped the connection — which the app degrades from quietly
/// rather than treating as a crash. Matched on the error's string form to stay
/// decoupled from the transitive `web_socket` / `dart:io` exception types.
bool isBenignRealtimeDisconnect(Object error) {
  final text = '$error';
  return text.contains('WebSocketConnectionClosed') ||
      text.contains('WebSocketException') ||
      text.contains('Connection Closed') ||
      text.contains('Connection reset');
}
