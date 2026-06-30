import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/constants/socket_events.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';

void main() {
  group('Outbound events (US5)', () {
    test('MessageSend → correct wire name + payload', () {
      const e = MessageSend(
        conversationId: 'c1',
        body: 'hi',
        idempotencyKey: 'k1',
      );
      expect(e.name, SocketEvents.messageSend);
      expect(e.data, {
        'conversationId': 'c1',
        'body': 'hi',
        'idempotencyKey': 'k1',
      });
    });

    test('typing + presence wire names', () {
      expect(const TypingStart('c1').name, SocketEvents.typingStart);
      expect(const TypingStop('c1').name, SocketEvents.typingStop);
      expect(const PresencePing().name, SocketEvents.presencePing);
      expect(const PresencePing().data, isEmpty);
    });
  });

  group('Inbound parsing (US5)', () {
    test('message.new → MessageNew', () {
      final e = InboundEvent.parse(SocketEvents.messageNew, {
        'conversationId': 'c1',
        'message': {'id': 'm1', 'body': 'hello'},
      });
      expect(e, isA<MessageNew>());
      expect((e as MessageNew).conversationId, 'c1');
      expect(e.message['id'], 'm1');
    });

    test('presence.update → PresenceUpdate', () {
      final e = InboundEvent.parse(SocketEvents.presenceUpdate, {
        'userId': 'u1',
        'online': true,
      });
      expect(e, isA<PresenceUpdate>());
      expect((e as PresenceUpdate).online, isTrue);
    });

    test('unknown event name → UnknownInbound (forward-compatible)', () {
      final e = InboundEvent.parse('some.future.event', {'x': 1});
      expect(e, isA<UnknownInbound>());
      expect((e as UnknownInbound).name, 'some.future.event');
    });
  });
}
