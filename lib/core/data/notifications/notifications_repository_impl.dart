import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/notifications_dao.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/notifications/notifications_remote_data_source.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/push/push_models.dart';

/// Real [NotificationsRepository] (#013, B#013). The Activity feed is a reactive
/// drift read (one canonical copy); pages fetched from the server are upserted
/// into the cache; mark-all-read hits the server then mirrors locally; live
/// entries fold in via [foldLiveEntry]. Registered only in `env:['real']` — the
/// app runs the fake.
@LazySingleton(as: NotificationsRepository, env: ['real'])
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote, this._db);

  final NotificationsRemoteDataSource _remote;
  final AppDatabase _db;

  NotificationsDao get _dao => _db.notificationsDao;

  @override
  Stream<List<NotificationEntry>> watchFeed() => _dao.watchFeed();

  @override
  Future<Result<CursorPage<NotificationEntry>>> loadPage({
    String? cursor,
  }) async {
    final res = await _remote.list(cursor: cursor);
    final page = res.valueOrNull;
    if (page != null) await _dao.upsertAll(page.items);
    return res;
  }

  @override
  Future<Result<void>> refresh() async {
    final res = await _remote.list();
    final page = res.valueOrNull;
    if (page != null) await _dao.upsertAll(page.items);
    return res.fold((_) => const Result.ok(null), Result.err);
  }

  @override
  Future<Result<int>> fetchUnreadCount() => _remote.unreadCount();

  @override
  Future<Result<void>> markAllRead() async {
    final res = await _remote.markAllRead();
    if (res.isOk) await _dao.markAllReadLocal(DateTime.now().toUtc());
    return res;
  }

  @override
  Future<void> foldLiveEntry(NotificationEntry entry) =>
      _dao.upsertEntry(entry);

  @override
  Future<Result<RegisteredDevice>> registerDevice(
    String platform,
    String token,
  ) => _remote.registerDevice(platform, token);

  @override
  Future<Result<void>> unregisterDevice(String token) =>
      _remote.unregisterDevice(token);
}
