import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/domain/result.dart';

/// The recency section an entry falls in (design: New / This week / Earlier).
enum ActivitySection { isNew, thisWeek, earlier }

/// A rendered section of the Activity feed (label + its entries, newest first).
class NotificationSectionGroup {
  const NotificationSectionGroup(this.section, this.entries);

  final ActivitySection section;
  final List<NotificationEntry> entries;
}

/// Watch the one canonical Activity feed (reactive cache).
@injectable
class WatchNotifications {
  const WatchNotifications(this._repo);
  final NotificationsRepository _repo;
  Stream<List<NotificationEntry>> call() => _repo.watchFeed();
}

/// Load a page of the feed from the server into the cache (cursor).
@injectable
class LoadNotificationsPage {
  const LoadNotificationsPage(this._repo);
  final NotificationsRepository _repo;
  Future<Result<CursorPage<NotificationEntry>>> call({String? cursor}) =>
      _repo.loadPage(cursor: cursor);
}

/// Reconcile the newest page (pull-to-refresh).
@injectable
class RefreshNotifications {
  const RefreshNotifications(this._repo);
  final NotificationsRepository _repo;
  Future<Result<void>> call() => _repo.refresh();
}

/// Mark all read (on Activity open) — clears the badge.
@injectable
class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this._repo);
  final NotificationsRepository _repo;
  Future<Result<void>> call() => _repo.markAllRead();
}

/// Fetch the authoritative unread count (badge seed).
@injectable
class FetchUnreadCount {
  const FetchUnreadCount(this._repo);
  final NotificationsRepository _repo;
  Future<Result<int>> call() => _repo.fetchUnreadCount();
}

/// Follow back a new follower from the Activity feed (#013 US5) — reuses the
/// shipped #010 follow toggle (idempotent). Request approval is deferred to #014.
@injectable
class FollowBack {
  const FollowBack(this._profiles);
  final ProfileRepository _profiles;
  Future<Result<void>> call(String userId) async {
    final res = await _profiles.follow(userId);
    return res.fold((_) => const Result.ok(null), Result.err);
  }
}

/// Bucket entries into New (today) / This week (≤7d) / Earlier by [now], keeping
/// newest-first order within each. Pure — the caller passes a (frozen-in-tests)
/// clock. Empty sections are omitted.
List<NotificationSectionGroup> sectionEntries(
  List<NotificationEntry> entries,
  DateTime now,
) {
  final sorted = [...entries]
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  final today = DateTime(now.year, now.month, now.day);
  final weekAgo = today.subtract(const Duration(days: 6));
  final buckets = <ActivitySection, List<NotificationEntry>>{
    ActivitySection.isNew: [],
    ActivitySection.thisWeek: [],
    ActivitySection.earlier: [],
  };
  for (final e in sorted) {
    final at = e.updatedAt.toLocal();
    if (!at.isBefore(today)) {
      buckets[ActivitySection.isNew]!.add(e);
    } else if (!at.isBefore(weekAgo)) {
      buckets[ActivitySection.thisWeek]!.add(e);
    } else {
      buckets[ActivitySection.earlier]!.add(e);
    }
  }
  return [
    for (final s in ActivitySection.values)
      if (buckets[s]!.isNotEmpty) NotificationSectionGroup(s, buckets[s]!),
  ];
}
