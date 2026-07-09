import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/services/push/push_service.dart';

/// In-memory [PushService] (#013) — the graph the app runs (zero network, **no
/// Firebase**) and hermetic tests use. Tests script the permission verdict, emit
/// a token, and emit taps/foreground messages; no OS prompt ever shows.
@LazySingleton(as: PushService, env: ['fake'])
class FakePushService implements PushService {
  /// The verdict [requestPermission] returns (default: granted for the running app).
  PushPermissionStatus scriptedStatus = PushPermissionStatus.granted;

  /// Number of times [requestPermission] was called (test inspection).
  int requestCount = 0;

  final StreamController<String> _tokens = StreamController<String>.broadcast();
  final StreamController<PushTapData> _taps =
      StreamController<PushTapData>.broadcast();
  final StreamController<PushForegroundData> _fg =
      StreamController<PushForegroundData>.broadcast();

  /// The cold-start tap tests can seed (see [initialTap]).
  @visibleForTesting
  PushTapData? initialTapValue;

  @override
  Future<void> initialize() async {}

  @override
  Future<PushPermissionStatus> requestPermission() async {
    requestCount++;
    return scriptedStatus;
  }

  @override
  Future<PushPermissionStatus> currentStatus() async => scriptedStatus;

  @override
  Stream<String> get tokenStream => _tokens.stream;

  @override
  Stream<PushTapData> get onNotificationTap => _taps.stream;

  @override
  Stream<PushForegroundData> get onForegroundMessage => _fg.stream;

  @override
  Future<PushTapData?> initialTap() async => initialTapValue;

  // ---- test hooks --------------------------------------------------------

  /// Emit a device token (drives `RegisterDevice`).
  @visibleForTesting
  void emitToken(String token) => _tokens.add(token);

  /// Emit a tapped notification (coarse deep-link routing).
  @visibleForTesting
  void emitTap(PushTapData tap) => _taps.add(tap);

  /// Emit a foreground message (local presentation).
  @visibleForTesting
  void emitForeground(PushForegroundData msg) => _fg.add(msg);

  @visibleForTesting
  Future<void> dispose() async {
    await _tokens.close();
    await _taps.close();
    await _fg.close();
  }
}
