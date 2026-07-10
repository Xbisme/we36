import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/notifications/fake_notifications_repository.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/core/services/realtime/notifications_realtime_service.dart';
import 'package:we36/core/utils/app_logger.dart';

NotificationNew _event(String id, {int unread = 1}) => NotificationNew(
  entry: {
    'id': id,
    'type': 'like',
    'actors': [
      {'id': 'u1', 'username': 'mia'},
    ],
    'actorCount': 1,
    'createdAt': '2026-07-08T12:00:00Z',
    'updatedAt': '2026-07-08T12:00:00Z',
  },
  unreadCount: unread,
);

void main() {
  late FakeRealtimeClient client;
  late FakeNotificationsRepository repo;
  late NotificationsBadge badge;
  late NotificationsRealtimeService service;

  setUp(() {
    client = FakeRealtimeClient();
    repo = FakeNotificationsRepository();
    badge = NotificationsBadge();
    service = NotificationsRealtimeService(
      client,
      repo,
      badge,
      const AppLogger(),
    );
  });

  tearDown(() async {
    await service.dispose();
    await client.dispose();
  });

  test(
    'folds a live notification.new into the cache + bumps the badge',
    () async {
      client.emitInbound(_event('live1', unread: 5));
      await Future<void>.delayed(Duration.zero);

      final feed = await repo.watchFeed().first;
      expect(feed.any((e) => e.id == 'live1'), isTrue);
      expect(badge.current, 5);
    },
  );

  test('a duplicate event does not create a second row (SC-004)', () async {
    client
      ..emitInbound(_event('dup', unread: 2))
      ..emitInbound(_event('dup', unread: 3));
    await Future<void>.delayed(Duration.zero);

    final feed = await repo.watchFeed().first;
    expect(feed.where((e) => e.id == 'dup'), hasLength(1));
    expect(badge.current, 3); // latest count wins
  });

  test('a malformed payload (no id) is skipped, no crash', () async {
    client.emitInbound(
      const NotificationNew(entry: {'type': 'like'}, unreadCount: 9),
    );
    await Future<void>.delayed(Duration.zero);

    final feed = await repo.watchFeed().first;
    // Only the fake's seeded entries — no id-less row added.
    expect(feed.any((e) => e.id.isEmpty), isFalse);
  });

  test('non-notification events are ignored', () async {
    client.emitInbound(const TypingInbound(conversationId: 'c1', userId: 'u1'));
    await Future<void>.delayed(Duration.zero);
    expect(badge.current, 0);
  });
}
