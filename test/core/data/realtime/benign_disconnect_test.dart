import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';

/// Guards the realtime resilience fix: socket_io_client's `WebSocketConnectionClosed`
/// (thrown from its own destroy microtask) is classified as a benign transport
/// close so it degrades quietly instead of escaping as an uncaught error
/// (Constitution VIII).
class _FakeError implements Exception {
  _FakeError(this.message);
  final String message;
  @override
  String toString() => message;
}

void main() {
  group('isBenignRealtimeDisconnect (#014 realtime hardening)', () {
    test('classifies the observed socket_io_client close as benign', () {
      expect(
        isBenignRealtimeDisconnect(
          _FakeError('WebSocketConnectionClosed: Connection Closed'),
        ),
        isTrue,
      );
    });

    test('classifies WebSocketException + connection reset as benign', () {
      expect(
        isBenignRealtimeDisconnect(_FakeError('WebSocketException: bad state')),
        isTrue,
      );
      expect(
        isBenignRealtimeDisconnect(
          _FakeError('SocketException: Connection reset'),
        ),
        isTrue,
      );
    });

    test('does NOT swallow an unrelated programmer error', () {
      expect(
        isBenignRealtimeDisconnect(
          _FakeError('type Null is not a subtype of String'),
        ),
        isFalse,
      );
      expect(isBenignRealtimeDisconnect(ArgumentError('bad')), isFalse);
    });
  });
}
