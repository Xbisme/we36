import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/notifications_table.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';

part 'notifications_dao.g.dart';

/// DAO for the persisted Activity feed cache (#013). Maps drift rows ↔ domain
/// [NotificationEntry], exposes the reactive read the feed watches + a keyset
/// [page], and clears on logout (Constitution I/IX). Dedupe of a
/// re-delivered / re-fetched group is by its `id` (primary key) — an upsert on
/// the same id updates in place, so an entry never appears twice (SC-004). The
/// unread count is NOT derived here (server marker — R5).
@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.attachedDatabase);

  /// Reactive feed, newest-activity first — the Activity screen render source.
  Stream<List<NotificationEntry>> watchFeed() {
    final query = select(notifications)
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toEntry).toList());
  }

  /// One-shot keyset page (older than [before], if given) for `PaginatedListCubit`.
  /// [before] is the cursor's `updatedAt`; null loads the newest page.
  Future<List<NotificationEntry>> page({
    DateTime? before,
    int limit = 20,
  }) async {
    final query = select(notifications)
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    if (before != null) {
      query.where((t) => t.updatedAt.isSmallerThanValue(before));
    }
    return (await query.get()).map(_toEntry).toList();
  }

  /// Upsert one entry (live fold / page reconcile) — deduped by id.
  Future<void> upsertEntry(NotificationEntry e) =>
      into(notifications).insertOnConflictUpdate(_companion(e));

  /// Upsert many entries (first load / page reconcile) — each deduped by id.
  Future<void> upsertAll(List<NotificationEntry> list) => batch(
    (b) => b.insertAllOnConflictUpdate(
      notifications,
      list.map(_companion).toList(),
    ),
  );

  /// Optimistically mirror mark-all-read — flip cached `isRead` for entries at or
  /// before [lastReadAt] (the server advances one `lastReadAt` marker).
  Future<void> markAllReadLocal(DateTime lastReadAt) =>
      (update(notifications)
            ..where((t) => t.updatedAt.isSmallerOrEqualValue(lastReadAt)))
          .write(const NotificationsCompanion(isRead: Value(true)));

  /// Clear the Activity cache on logout / forced re-login.
  Future<void> clearUserScoped() => delete(notifications).go();

  // ---- mapping -----------------------------------------------------------

  NotificationsCompanion _companion(NotificationEntry e) =>
      NotificationsCompanion.insert(
        id: e.id,
        type: e.type.name,
        actorsJson: jsonEncode(e.actors.map((a) => a.toJson()).toList()),
        actorCount: Value(e.actorCount),
        targetJson: Value(
          e.target == null ? null : jsonEncode(e.target!.toJson()),
        ),
        isRead: Value(e.isRead),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  NotificationEntry _toEntry(CachedNotification row) {
    final rawActors = jsonDecode(row.actorsJson);
    final actors = <ActorCard>[
      if (rawActors is List)
        for (final a in rawActors)
          if (a is Map) ActorCard.fromJson(a.cast<String, dynamic>()),
    ];
    final targetJson = row.targetJson;
    return NotificationEntry(
      id: row.id,
      type: NotificationType.values.firstWhere(
        (t) => t.name == row.type,
        orElse: () => NotificationType.unknown,
      ),
      actors: actors,
      actorCount: row.actorCount,
      target: targetJson == null
          ? null
          : NotificationTarget.fromJson(
              (jsonDecode(targetJson) as Map).cast<String, dynamic>(),
            ),
      isRead: row.isRead,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
