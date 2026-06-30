import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';

/// In-memory [RealtimeClient] (no socket) — the default for #002 and for tests.
/// Captures sent events and lets tests script inbound events + connection drops.
@LazySingleton(as: RealtimeClient, env: ['fake'])
class FakeRealtimeClient implements RealtimeClient {
  final StreamController<RealtimeConnectionState> _stateController =
      StreamController<RealtimeConnectionState>.broadcast();
  final StreamController<InboundEvent> _eventController =
      StreamController<InboundEvent>.broadcast();

  /// Outbound events the client sent (test inspection).
  final List<OutboundEvent> sent = [];

  /// Token last passed to [connect] (test inspection).
  String? lastToken;

  RealtimeConnectionState _state = const RtDisconnected();

  @override
  Stream<RealtimeConnectionState> get connectionState =>
      _stateController.stream;

  @override
  Stream<InboundEvent> get events => _eventController.stream;

  @override
  RealtimeConnectionState get state => _state;

  @override
  void connect(String accessToken) {
    lastToken = accessToken;
    _emit(const RtConnecting());
    _emit(const RtConnected());
  }

  @override
  void send(OutboundEvent event) => sent.add(event);

  @override
  Future<void> disconnect() async => _emit(const RtDisconnected());

  /// Test hook: deliver a server→client event.
  void emitInbound(InboundEvent event) => _eventController.add(event);

  /// Test hook: simulate a transient drop with auto-recovery.
  void simulateDrop() {
    _emit(const RtReconnecting());
    _emit(const RtConnected());
  }

  void _emit(RealtimeConnectionState next) {
    _state = next;
    if (!_stateController.isClosed) _stateController.add(next);
  }

  /// Close the controllers (call from tests).
  Future<void> dispose() async {
    await _stateController.close();
    await _eventController.close();
  }
}
