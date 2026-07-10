import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';

NotificationEntry _entry(
  String id, {
  required DateTime at,
  bool isRead = false,
  NotificationTarget? target,
}) => NotificationEntry(
  id: id,
  type: NotificationType.like,
  actors: [ActorCard(id: 'u-$id', username: 'a$id')],
  target: target,
  isRead: isRead,
  createdAt: at,
  updatedAt: at,
);

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('upsertEntry dedupes by id (one row per id, SC-004)', () async {
    final at = DateTime.utc(2026, 7, 8, 12);
    await db.notificationsDao.upsertEntry(_entry('n1', at: at));
    // A re-delivered group with the same id updates in place (no duplicate).
    await db.notificationsDao.upsertEntry(_entry('n1', at: at, isRead: true));
    final feed = await db.notificationsDao.watchFeed().first;
    expect(feed, hasLength(1));
    expect(feed.single.isRead, isTrue);
  });

  test('watchFeed orders newest-activity first', () async {
    await db.notificationsDao.upsertAll([
      _entry('old', at: DateTime.utc(2026, 7)),
      _entry('new', at: DateTime.utc(2026, 7, 8)),
      _entry('mid', at: DateTime.utc(2026, 7, 4)),
    ]);
    final feed = await db.notificationsDao.watchFeed().first;
    expect(feed.map((e) => e.id), ['new', 'mid', 'old']);
  });

  test('page() keyset-paginates by updatedAt', () async {
    for (var i = 0; i < 5; i++) {
      await db.notificationsDao.upsertEntry(
        _entry('n$i', at: DateTime.utc(2026, 7, 1 + i)),
      );
    }
    final firstTwo = await db.notificationsDao.page(limit: 2);
    expect(firstTwo.map((e) => e.id), ['n4', 'n3']);
    final next = await db.notificationsDao.page(
      before: firstTwo.last.updatedAt,
      limit: 2,
    );
    expect(next.map((e) => e.id), ['n2', 'n1']);
  });

  test('markAllReadLocal flips isRead up to the marker', () async {
    await db.notificationsDao.upsertAll([
      _entry('a', at: DateTime.utc(2026, 7)),
      _entry('b', at: DateTime.utc(2026, 7, 8)),
    ]);
    await db.notificationsDao.markAllReadLocal(DateTime.utc(2026, 7, 5));
    final feed = await db.notificationsDao.watchFeed().first;
    expect(feed.firstWhere((e) => e.id == 'a').isRead, isTrue);
    expect(feed.firstWhere((e) => e.id == 'b').isRead, isFalse);
  });

  test('round-trips a null vs present target', () async {
    await db.notificationsDao.upsertAll([
      _entry(
        'withTarget',
        at: DateTime.utc(2026, 7, 2),
        target: const NotificationTarget(kind: TargetKind.post, id: 'p1'),
      ),
      _entry('noTarget', at: DateTime.utc(2026, 7)),
    ]);
    final feed = await db.notificationsDao.watchFeed().first;
    expect(feed.firstWhere((e) => e.id == 'withTarget').target!.id, 'p1');
    expect(feed.firstWhere((e) => e.id == 'noTarget').target, isNull);
  });

  test('clearUserScoped wipes the Activity feed', () async {
    await db.notificationsDao.upsertEntry(_entry('n1', at: DateTime.utc(2026)));
    await db.clearUserScoped();
    expect(await db.notificationsDao.watchFeed().first, isEmpty);
  });
}
