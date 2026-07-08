import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/constants/socket_events.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';

void main() {
  // Regression for the #013 scaffold fix (T016): #002 parsed a `notification`
  // wrapper, but B#013 emits `{entry, unreadCount}`.
  test('notification.new parses the real {entry, unreadCount} payload', () {
    final event = InboundEvent.parse(SocketEvents.notificationNew, {
      'entry': {'id': 'n1', 'type': 'like'},
      'unreadCount': 7,
    });
    expect(event, isA<NotificationNew>());
    final n = event as NotificationNew;
    expect(n.entry['id'], 'n1');
    expect(n.unreadCount, 7);
  });

  test('a missing payload degrades to empty entry + zero count', () {
    final n =
        InboundEvent.parse(SocketEvents.notificationNew, const {})
            as NotificationNew;
    expect(n.entry, isEmpty);
    expect(n.unreadCount, 0);
  });
}
