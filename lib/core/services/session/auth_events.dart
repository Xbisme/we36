import 'dart:async';

import 'package:injectable/injectable.dart';

/// Emits a single "unauthenticated" signal when token refresh fails, so the
/// session layer (#003) can log out and route to auth — exactly once, never per
/// in-flight request (Constitution VIII).
abstract interface class AuthEventsSink {
  /// Fire the unauthenticated signal (idempotent per refresh failure).
  void onUnauthenticated();

  /// Stream the session layer listens to (broadcast; #003).
  Stream<void> get unauthenticated;
}

/// Concrete broadcast implementation — pure client-side, used in every flavor
/// (no fake needed). The refresh interceptor calls [onUnauthenticated] once when
/// a single-flight refresh fails.
@LazySingleton(as: AuthEventsSink)
class AuthEvents implements AuthEventsSink {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  /// Count of signals emitted (assert exactly-once in tests).
  int signalCount = 0;

  @override
  void onUnauthenticated() {
    signalCount++;
    if (!_controller.isClosed) _controller.add(null);
  }

  @override
  Stream<void> get unauthenticated => _controller.stream;

  /// Close the broadcast controller (call from tests; the app-lifetime singleton
  /// is torn down with the DI scope).
  void dispose() => _controller.close();
}
