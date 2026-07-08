import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_state.dart';

NotificationEntry stubEntry(
  String id,
  NotificationType type, {
  int actorCount = 1,
  NotificationTarget? target,
  bool isRead = false,
}) => NotificationEntry(
  id: id,
  type: type,
  actors: [
    ActorCard(id: 'u-$id', username: 'mia', displayName: 'Mia'),
    if (actorCount > 1) const ActorCard(id: 'u2', username: 'leo'),
  ],
  actorCount: actorCount,
  target: target,
  isRead: isRead,
  createdAt: DateTime.utc(2026, 7, 8),
  updatedAt: DateTime.utc(2026, 7, 8),
);

/// Seeded sections for Activity widget tests (no drift/socket/Firebase).
List<NotificationSectionGroup> stubSections() => [
  NotificationSectionGroup(ActivitySection.isNew, [
    stubEntry(
      'n1',
      NotificationType.like,
      actorCount: 5,
      // No thumbnailUrl → the golden stays network-free + deterministic.
      target: const NotificationTarget(kind: TargetKind.post, id: 'p1'),
    ),
    stubEntry('n2', NotificationType.follow),
  ]),
  NotificationSectionGroup(ActivitySection.earlier, [
    // A deleted-target (degraded) row.
    stubEntry('n3', NotificationType.comment, isRead: true),
  ]),
];

/// A [NotificationsCubit] seeded with a fixed state — widget tests never drive
/// the real cubit over drift/Firebase (the #009 gate learning).
class StubNotificationsCubit extends Cubit<NotificationsState>
    implements NotificationsCubit {
  StubNotificationsCubit(super.initialState);

  @override
  DateTime Function() clock = DateTime.now;

  @override
  Future<void> loadInitial() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<void> retry() async {}

  @override
  Future<bool> followBack(String userId) async => true;
}
