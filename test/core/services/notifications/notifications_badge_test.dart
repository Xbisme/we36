import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';

void main() {
  test('replays the last-known count to a new listener', () async {
    final badge = NotificationsBadge()..push(4);
    expect(await badge.unreadCount.first, 4);
    expect(badge.current, 4);
  });

  test('current tracks pushes; negative clamps to 0', () {
    final badge = NotificationsBadge()..push(5);
    expect(badge.current, 5);
    badge.push(-1);
    expect(badge.current, 0);
  });

  test('stream delivers pushed counts to a listener', () async {
    final badge = NotificationsBadge();
    final seen = <int>[];
    final sub = badge.unreadCount.listen(seen.add);
    await Future<void>.delayed(Duration.zero); // let the stream attach
    badge.push(3);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(seen, containsAllInOrder([0, 3]));
  });

  test('clear resets to 0 (mark-all-read on open)', () async {
    final badge = NotificationsBadge()
      ..push(7)
      ..clear();
    expect(badge.current, 0);
  });
}
