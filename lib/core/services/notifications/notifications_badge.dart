import 'dart:async';

import 'package:injectable/injectable.dart';

/// The Activity unread-count source (#013) for the Home-header bell (phone) and
/// the SidebarRail "Notifications" item (tablet). A **core→core** seam so
/// `core/presentation` never imports `features/notifications` (Constitution XI;
/// mirrors `MessagingBadge`). Read state is a server `lastReadAt` marker, so the
/// count is server-owned (not derived from cached rows, R5): seeded from
/// `GET /notifications/unread-count`, bumped by each `notification.new`
/// (`NotificationsRealtimeService`), and reset to 0 on mark-all-read (open).
@lazySingleton
class NotificationsBadge {
  final StreamController<int> _controller = StreamController<int>.broadcast();
  int _last = 0;

  /// The unread count, replaying the last-known value to new listeners.
  Stream<int> get unreadCount async* {
    yield _last;
    yield* _controller.stream;
  }

  /// The latest known unread count.
  int get current => _last;

  /// Publish a new unread count.
  void push(int count) {
    _last = count < 0 ? 0 : count;
    if (!_controller.isClosed) _controller.add(_last);
  }

  /// Reset to zero (mark-all-read on open).
  void clear() => push(0);
}
