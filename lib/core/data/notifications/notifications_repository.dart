import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/push/push_models.dart';

/// The Notifications & Push data seam (#013, B#013 — source-verified; Constitution
/// VIII/IX). Screens consume this via use cases — never HTTP or the socket
/// directly. A real impl (`env:['real']`) and an in-memory fake (`env:['fake']`,
/// the one that runs) exist. The Activity feed is the one canonical cached copy
/// (reactive drift cache); grouping + read state are server-owned; live
/// `notification.new` is folded into the cache by `NotificationsRealtimeService`.
abstract interface class NotificationsRepository {
  /// Reactive Activity feed (newest-activity first) — the render source. Cache
  /// first (renders offline-from-cache, FR-012).
  Stream<List<NotificationEntry>> watchFeed();

  /// Load a page of the feed (`GET /notifications`, cursor) into the cache.
  Future<Result<CursorPage<NotificationEntry>>> loadPage({String? cursor});

  /// Reconcile the newest page with the server (pull-to-refresh). Errors surface
  /// without clearing the cache.
  Future<Result<void>> refresh();

  /// The current unread count (`GET /notifications/unread-count`) — badge seed.
  Future<Result<int>> fetchUnreadCount();

  /// Mark all notifications read (`POST /notifications/read`) + mirror locally.
  Future<Result<void>> markAllRead();

  /// Fold a live `notification.new` entry into the canonical cache (dedupe by id).
  /// Called by `NotificationsRealtimeService`.
  Future<void> foldLiveEntry(NotificationEntry entry);

  /// Register (or refresh) this device's push token (`POST /devices`).
  Future<Result<RegisteredDevice>> registerDevice(
    String platform,
    String token,
  );

  /// Unregister a device push token (`DELETE /devices/:token`, idempotent).
  Future<Result<void>> unregisterDevice(String token);
}
