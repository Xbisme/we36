import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/notifications/notifications_dto.dart';

void main() {
  group('notificationEntryFromDto', () {
    test('decodes a grouped entry with actors + target', () {
      final e = notificationEntryFromDto({
        'id': 'n1',
        'type': 'like',
        'actors': [
          {
            'id': 'u1',
            'username': 'mia',
            'displayName': 'Mia',
            'avatarUrl': null,
          },
          {'id': 'u2', 'username': 'leo'},
        ],
        'actorCount': 5,
        'target': {'kind': 'post', 'id': 'p1', 'thumbnailUrl': 't.jpg'},
        'isRead': false,
        'createdAt': '2026-07-08T10:00:00Z',
        'updatedAt': '2026-07-08T12:00:00Z',
      });
      expect(e.id, 'n1');
      expect(e.type, NotificationType.like);
      expect(e.actors, hasLength(2));
      expect(e.actors.first.avatarUrl, isNull); // tolerated
      expect(e.actorCount, 5);
      expect(e.andOthersCount, 4);
      expect(e.target!.kind, TargetKind.post);
      expect(e.target!.thumbnailUrl, 't.jpg');
      expect(e.isDegraded, isFalse);
    });

    test('null target ⇒ degraded, non-follow entry', () {
      final e = notificationEntryFromDto({
        'id': 'n2',
        'type': 'comment',
        'actors': const <Map<String, dynamic>>[],
        'actorCount': 1,
        'target': null,
        'isRead': true,
        'createdAt': '2026-07-08T10:00:00Z',
        'updatedAt': '2026-07-08T10:00:00Z',
      });
      expect(e.target, isNull);
      expect(e.isDegraded, isTrue);
    });

    test('follow entry with no target is NOT degraded', () {
      final e = notificationEntryFromDto({
        'id': 'n3',
        'type': 'follow',
        'actors': [
          {'id': 'u9', 'username': 'sam'},
        ],
        'actorCount': 1,
        'target': null,
        'isRead': false,
        'createdAt': '2026-07-08T10:00:00Z',
        'updatedAt': '2026-07-08T10:00:00Z',
      });
      expect(e.isFollowType, isTrue);
      expect(e.isDegraded, isFalse);
    });

    test('unknown enum values fall back to unknown', () {
      final e = notificationEntryFromDto({
        'id': 'n4',
        'type': 'sparkle', // not a real type
        'target': {'kind': 'galaxy', 'id': 'x'},
        'createdAt': '2026-07-08T10:00:00Z',
        'updatedAt': '2026-07-08T10:00:00Z',
      });
      expect(e.type, NotificationType.unknown);
      expect(e.target!.kind, TargetKind.unknown);
    });

    test('all seven feed types decode', () {
      for (final name in [
        'like',
        'comment',
        'reply',
        'mention',
        'follow',
        'followRequest',
        'followAccepted',
      ]) {
        final e = notificationEntryFromDto({
          'id': 'x',
          'type': name,
          'createdAt': '2026-07-08T10:00:00Z',
          'updatedAt': '2026-07-08T10:00:00Z',
        });
        expect(e.type.name, name);
      }
    });
  });

  test('registerDeviceBody shapes {platform, token}', () {
    expect(registerDeviceBody('ios', 'tok-123'), {
      'platform': 'ios',
      'token': 'tok-123',
    });
  });
}
