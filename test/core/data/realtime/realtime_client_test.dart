import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';

void main() {
  group('RealtimeClient scaffold (US5 / SC-006)', () {
    test('connect authenticates and reaches connected', () async {
      final client = FakeRealtimeClient();
      final states = <RealtimeConnectionState>[];
      final sub = client.connectionState.listen(states.add);

      client.connect('access-token-123');
      await Future<void>.delayed(Duration.zero);

      expect(client.lastToken, 'access-token-123');
      expect(states.last, isA<RtConnected>());
      await sub.cancel();
      await client.dispose();
    });

    test('induced drop → reconnecting → connected', () async {
      final client = FakeRealtimeClient();
      final states = <RealtimeConnectionState>[];
      final sub = client.connectionState.listen(states.add);

      client
        ..connect('t')
        ..simulateDrop();
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s is RtReconnecting), isTrue);
      expect(states.last, isA<RtConnected>());
      await sub.cancel();
      await client.dispose();
    });

    test('round-trips a typed event in each direction', () async {
      final client = FakeRealtimeClient();
      final received = <InboundEvent>[];
      final sub = client.events.listen(received.add);

      // Outbound captured.
      client.send(
        const MessageSend(
          conversationId: 'c1',
          body: 'hi',
          idempotencyKey: 'k',
        ),
      );
      expect(client.sent.single, isA<MessageSend>());

      // Inbound delivered.
      client.emitInbound(const PresenceUpdate(userId: 'u1', online: true));
      await Future<void>.delayed(Duration.zero);
      expect(received.single, isA<PresenceUpdate>());

      await sub.cancel();
      await client.dispose();
    });
  });
}
