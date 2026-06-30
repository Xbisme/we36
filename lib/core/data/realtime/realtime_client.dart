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
  }

  @override
  void send(OutboundEvent event) => _socket?.emit(event.name, event.data);

  @override
  Future<void> disconnect() async {
    _socket?.dispose();
    _socket = null;
    _setState(const RtDisconnected());
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map ? data.cast<String, dynamic>() : const {};

  /// Tear down the socket + controllers (call when retiring the singleton).
  Future<void> dispose() async {
    _socket?.dispose();
    await _stateController.close();
    await _eventController.close();
  }
}
