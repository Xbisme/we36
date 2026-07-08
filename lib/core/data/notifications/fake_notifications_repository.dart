import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/push/push_models.dart';

/// In-memory [NotificationsRepository] (#013) — the graph the app runs (zero
/// network, no Firebase) and hermetic tests use. Seeds entries of every type
/// incl. a grouped like, a deleted-target (degraded) row, and a mix of read /
/// unread across time buckets (enough for ≥2 keyset pages). [failNext] forces the
/// next network call to fail (rollback/offline tests). Timestamps are seeded
/// relative to [clock] (default wall clock) so no fixed date can expire.
@LazySingleton(as: NotificationsRepository, env: ['fake'])
class FakeNotificationsRepository implements NotificationsRepository {
  FakeNotificationsRepository();

  /// Injectable clock (override in tests to freeze time).
  DateTime Function() clock = () => DateTime.now().toUtc();

  /// Force the next remote-backed call to return a failure.
  bool failNext = false;

  /// Captured device registrations / unregistrations (test inspection).
  final List<String> registeredTokens = [];
  final List<String> unregisteredTokens = [];

  final StreamController<List<NotificationEntry>> _controller =
      StreamController<List<NotificationEntry>>.broadcast();

  List<NotificationEntry>? _seed;
  static const int _pageSize = 20;

  List<NotificationEntry> get _entries => _seed ??= _buildSeed();

  @override
  Stream<List<NotificationEntry>> watchFeed() async* {
    yield _sorted();
    yield* _controller.stream;
  }

  @override
  Future<Result<CursorPage<NotificationEntry>>> loadPage({
    String? cursor,
  }) async {
    if (failNext) {
      failNext = false;
      return const Result.err(AppFailure.networkError());
    }
    final all = _sorted();
    final start = int.tryParse(cursor ?? '0') ?? 0;
    final slice = all.skip(start).take(_pageSize).toList();
    final next = start + _pageSize;
    _notify();
    return Result.ok(
      CursorPage<NotificationEntry>(
        items: slice,
        nextCursor: next < all.length ? '$next' : null,
        hasMore: next < all.length,
      ),
    );
  }

  @override
  Future<Result<void>> refresh() async {
    if (failNext) {
      failNext = false;
      return const Result.err(AppFailure.networkError());
    }
    _notify();
    return const Result.ok(null);
  }

  @override
  Future<Result<int>> fetchUnreadCount() async {
    if (failNext) {
      failNext = false;
      return const Result.err(AppFailure.networkError());
    }
    return Result.ok(_entries.where((e) => !e.isRead).length);
  }

  @override
  Future<Result<void>> markAllRead() async {
    for (var i = 0; i < _entries.length; i++) {
      _entries[i] = _entries[i].copyWith(isRead: true);
    }
    _notify();
    return const Result.ok(null);
  }

  @override
  Future<void> foldLiveEntry(NotificationEntry entry) async {
    final i = _entries.indexWhere((e) => e.id == entry.id);
    if (i >= 0) {
      _entries[i] = entry; // dedupe by id — update in place (SC-004)
    } else {
      _entries.insert(0, entry);
    }
    _notify();
  }

  @override
  Future<Result<RegisteredDevice>> registerDevice(
    String platform,
    String token,
  ) async {
    if (failNext) {
      failNext = false;
      return const Result.err(AppFailure.networkError());
    }
    registeredTokens.add(token);
    return Result.ok(
      RegisteredDevice(
        id: 'dev-$token',
        platform: platform,
        createdAt: clock(),
      ),
    );
  }

  @override
  Future<Result<void>> unregisterDevice(String token) async {
    unregisteredTokens.add(token);
    return const Result.ok(null);
  }

  // ---- internals ---------------------------------------------------------

  List<NotificationEntry> _sorted() {
    final list = [..._entries]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  void _notify() {
    if (!_controller.isClosed) _controller.add(_sorted());
  }

  ActorCard _actor(String n) =>
      ActorCard(id: 'u-$n', username: n, displayName: n);

  List<NotificationEntry> _buildSeed() {
    final now = clock();
    NotificationEntry e(
      String id,
      NotificationType type, {
      required Duration ago,
      List<ActorCard>? actors,
      int actorCount = 1,
      NotificationTarget? target,
      bool isRead = false,
    }) {
      final at = now.subtract(ago);
      return NotificationEntry(
        id: id,
        type: type,
        actors: actors ?? [_actor('mia')],
        actorCount: actorCount,
        target: target,
        isRead: isRead,
        createdAt: at,
        updatedAt: at,
      );
    }

    const postTarget = NotificationTarget(
      kind: TargetKind.post,
      id: 'p1',
      thumbnailUrl: 'https://cdn.example/p1.jpg',
    );

    final seed = <NotificationEntry>[
      // New (today)
      e(
        'n1',
        NotificationType.like,
        ago: const Duration(hours: 1),
        actors: [_actor('mia'), _actor('leo'), _actor('sam')],
        actorCount: 5,
        target: postTarget,
      ),
      e(
        'n2',
        NotificationType.comment,
        ago: const Duration(hours: 4),
        target: postTarget,
      ),
      e('n3', NotificationType.follow, ago: const Duration(hours: 9)),
      // This week
      e(
        'n4',
        NotificationType.mention,
        ago: const Duration(days: 2),
        target: const NotificationTarget(
          kind: TargetKind.comment,
          id: 'c1',
          postId: 'p1',
        ),
        isRead: true,
      ),
      e(
        'n5',
        NotificationType.followRequest,
        ago: const Duration(days: 4),
      ),
      // Earlier (+ a deleted-target degraded row)
      e(
        'n6',
        NotificationType.followAccepted,
        ago: const Duration(days: 10),
        isRead: true,
      ),
      e(
        'n7',
        NotificationType.reply,
        ago: const Duration(days: 20),
        isRead: true,
      ),
    ];
    // Filler so the feed spans ≥2 keyset pages (pagination test).
    for (var i = 0; i < 18; i++) {
      seed.add(
        e(
          'nf$i',
          NotificationType.like,
          ago: Duration(days: 25 + i),
          target: postTarget,
          isRead: true,
        ),
      );
    }
    return seed;
  }

  @visibleForTesting
  Future<void> dispose() async => _controller.close();
}
