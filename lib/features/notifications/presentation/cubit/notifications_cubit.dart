import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_state.dart';

/// Drives the Activity screen (#013 US1). Reads the one canonical feed reactively
/// from the cache (renders offline-from-cache, FR-012), reconciles pages from the
/// server, time-sections the entries (New / This week / Earlier via an injectable
/// [clock], frozen in tests), marks all read on open (clears the badge, FR-008),
/// and folds live `notification.new` entries automatically (the cache is the one
/// source).
@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(
    this._watch,
    this._loadPage,
    this._refresh,
    this._markAllRead,
    this._fetchUnread,
    this._followBack,
    this._badge,
  ) : super(const NotificationsState.initial());

  final WatchNotifications _watch;
  final LoadNotificationsPage _loadPage;
  final RefreshNotifications _refresh;
  final MarkAllNotificationsRead _markAllRead;
  final FetchUnreadCount _fetchUnread;
  final FollowBack _followBack;
  final NotificationsBadge _badge;

  /// Injectable clock for time-sectioning (override/freeze in tests).
  DateTime Function() clock = DateTime.now;

  StreamSubscription<List<NotificationEntry>>? _sub;
  List<NotificationEntry> _latest = const [];
  bool _hasData = false;
  bool _offline = false;
  bool _hasMore = false;
  bool _loadingMore = false;
  String? _cursor;

  Future<void> loadInitial() async {
    emit(const NotificationsState.loading());
    _hasData = false;
    _offline = false;
    _sub ??= _watch().listen(_onData);

    final res = await _loadPage();
    res.fold(
      (page) {
        _hasMore = page.hasMore;
        _cursor = page.nextCursor;
      },
      (_) => _offline = true,
    );

    if (_hasData) {
      _emitLoaded();
    } else if (res.isErr) {
      emit(NotificationsState.error(res.failureOrNull!));
      return;
    } else {
      _emitLoaded();
    }

    // Opening the screen = "seen": mark all read + clear the badge (FR-008).
    await _markAllRead();
    _badge.clear();
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || _cursor == null) return;
    _loadingMore = true;
    _emitLoaded();
    final res = await _loadPage(cursor: _cursor);
    res.fold(
      (page) {
        _hasMore = page.hasMore;
        _cursor = page.nextCursor;
      },
      (_) {},
    );
    _loadingMore = false;
    _emitLoaded();
  }

  Future<void> refresh() async {
    final res = await _refresh();
    _offline = res.isErr;
    // Seed the badge from the authoritative count after a manual refresh.
    final count = await _fetchUnread();
    count.fold(_badge.push, (_) {});
    if (_hasData) _emitLoaded();
  }

  Future<void> retry() => loadInitial();

  /// Follow back the actor of a follow notification (US5) — optimistic; the
  /// button reverts on a false result.
  Future<bool> followBack(String userId) async {
    final res = await _followBack(userId);
    return res.isOk;
  }

  void _onData(List<NotificationEntry> entries) {
    _hasData = true;
    _latest = entries;
    _emitLoaded();
  }

  void _emitLoaded() {
    emit(
      NotificationsState.loaded(
        sections: sectionEntries(_latest, clock()),
        hasMore: _hasMore,
        loadingMore: _loadingMore,
        isOffline: _offline,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
