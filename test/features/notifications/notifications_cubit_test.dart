import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/notifications/fake_notifications_repository.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_state.dart';

void main() {
  late FakeNotificationsRepository repo;
  late NotificationsBadge badge;
  final frozen = DateTime.utc(2026, 7, 8, 12);

  NotificationsCubit build() {
    repo = FakeNotificationsRepository()..clock = () => frozen;
    badge = NotificationsBadge();
    return NotificationsCubit(
      WatchNotifications(repo),
      LoadNotificationsPage(repo),
      RefreshNotifications(repo),
      MarkAllNotificationsRead(repo),
      FetchUnreadCount(repo),
      FollowBack(FakeProfileRepository(RelationshipStore())),
      badge,
    )..clock = () => frozen;
  }

  test(
    'loadInitial → loaded with New / This week / Earlier sections',
    () async {
      final cubit = build();
      addTearDown(cubit.close);
      await cubit.loadInitial();

      final state = cubit.state;
      expect(state, isA<NotificationsLoaded>());
      final sections = (state as NotificationsLoaded).sections;
      final labels = sections.map((s) => s.section).toList();
      expect(labels, contains(ActivitySection.isNew));
      expect(labels, contains(ActivitySection.thisWeek));
      expect(labels, contains(ActivitySection.earlier));
      // Newest-first within the first (New) section.
      expect(sections.first.entries.first.id, 'n1');
    },
  );

  test('marks all read on open → badge cleared to 0 (FR-008/SC-003)', () async {
    final cubit = build();
    addTearDown(cubit.close);
    await cubit.loadInitial();
    expect(badge.current, 0);
  });

  test('pagination: hasMore true, then loadMore exhausts it', () async {
    final cubit = build();
    addTearDown(cubit.close);
    await cubit.loadInitial();
    expect((cubit.state as NotificationsLoaded).hasMore, isTrue);

    await cubit.loadMore();
    expect((cubit.state as NotificationsLoaded).hasMore, isFalse);
  });

  test(
    'a failed refresh surfaces isOffline but keeps the cached feed',
    () async {
      final cubit = build();
      addTearDown(cubit.close);
      await cubit.loadInitial();

      repo.failNext = true;
      await cubit.refresh();
      final state = cubit.state as NotificationsLoaded;
      expect(state.isOffline, isTrue);
      expect(state.sections, isNotEmpty); // cache still rendered
    },
  );
}
