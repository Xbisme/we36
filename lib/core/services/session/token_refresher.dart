import 'dart:async';

import 'package:injectable/injectable.dart';

/// Performs the single-flight access-token refresh for the auth interceptor
/// (Constitution VIII). #002 owns only this seam; the real refresh call
/// (`POST /v1/auth/refresh` + secure-storage rotation) lands with Auth #003.
// ignore: one_member_abstracts — intentional DI seam (real impl lands in #003).
abstract interface class TokenRefresher {
  /// Refresh the access token. Returns true on success (retry the request),
  /// false on failure (surface `sessionExpired` + the unauthenticated signal).
  Future<bool> refresh();
}

/// Default #002 implementation: always reports failure (no credentials yet), so
/// a `401` cleanly degrades to `sessionExpired` until #003 wires real refresh.
/// Test instances can script success + count calls to prove single-flight.
@LazySingleton(as: TokenRefresher)
class FakeTokenRefresher implements TokenRefresher {
  /// Whether [refresh] reports success (default: fail, until #003).
  bool succeeds = false;

  /// Number of times [refresh] has been invoked (assert single-flight == 1).
  int calls = 0;

  /// Optional hook awaited inside [refresh] (e.g. to widen the concurrency window).
  Future<void> Function()? beforeReturn;

  @override
  Future<bool> refresh() async {
    calls++;
    if (beforeReturn != null) await beforeReturn!();
    return succeeds;
  }
}
