import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/reels_dao.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_remote_data_source.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Real reels repository (B#007): remote pages reconciled into the drift cache,
/// reactive canonical reads, server-authoritative engagement reconciliation, and
/// idempotent create with optimistic top-of-feed insert (Constitution VIII/IX).
/// Registered only in the `real` environment — the in-memory fake runs until a
/// dev backend is wired.
@LazySingleton(as: ReelsRepository, env: ['real'])
class ReelsRepositoryImpl implements ReelsRepository {
  ReelsRepositoryImpl(this._remote, this._db);

  final ReelsRemoteDataSource _remote;
  final AppDatabase _db;

  // Post-publish transcode reconciliation cadence. Mutable only so tests can
  // shrink the wait; injectable builds this repo from its two real deps alone
  // (a constructor `Duration` param would make get_it try to resolve `Duration`).
  @visibleForTesting
  Duration pollInterval = const Duration(milliseconds: 1500);
  @visibleForTesting
  int pollMaxAttempts = 40; // ~60s ceiling for a slow/long transcode.

  ReelsDao get _dao => _db.reelsDao;

  @override
  Stream<List<Reel>> watchReelsFeed() => _dao.watchReelsFeed();

  @override
  Stream<Reel?> watchReel(String id) => _dao.watchReel(id);

  @override
  Future<void> applyCommentCountDelta(String id, int delta) =>
      _dao.adjustCommentCount(id, delta);

  @override
  Future<Result<CursorPage<Reel>>> loadFirstPage() async {
    final result = await _remote.getFeed(PageRequest());
    if (result.isOk) {
      // Replace the cached feed only after a successful fetch — a failed refresh
      // must keep the existing cache.
      await _dao.clearFeed();
      await _dao.upsertAll(result.valueOrNull!.items);
    }
    return result;
  }

  @override
  Future<Result<CursorPage<Reel>>> loadNextPage(String cursor) async {
    final result = await _remote.getFeed(PageRequest(cursor: cursor));
    if (result.isOk) {
      await _dao.upsertAll(result.valueOrNull!.items);
    }
    return result;
  }

  @override
  Future<Result<EngagementState>> toggleLike(
    String reelId, {
    required bool like,
  }) => _mutate(
    reelId,
    (r) => r.copyWith(
      viewerHasLiked: like,
      likeCount: r.likeCount + ((like ? 1 : 0) - (r.viewerHasLiked ? 1 : 0)),
    ),
    () => _remote.like(reelId, like: like),
  );

  @override
  Future<Result<EngagementState>> toggleSave(
    String reelId, {
    required bool save,
  }) => _mutate(
    reelId,
    (r) => r.copyWith(
      viewerHasSaved: save,
      saveCount: r.saveCount + ((save ? 1 : 0) - (r.viewerHasSaved ? 1 : 0)),
    ),
    () => _remote.save(reelId, save: save),
  );

  /// Optimistic write → server → reconcile / rollback (Constitution IX). The
  /// canonical drift copy flips instantly (reflected via [watchReelsFeed]); on
  /// failure the prior snapshot is restored; on success the server-authoritative
  /// counts are adopted.
  Future<Result<EngagementState>> _mutate(
    String reelId,
    Reel Function(Reel prior) toggle,
    Future<Result<EngagementState>> Function() remote,
  ) async {
    final prior = await _dao.getById(reelId);
    if (prior != null) await _dao.upsert(toggle(prior));
    final result = await remote();
    if (prior != null) {
      await result.fold(_dao.applyEngagement, (_) => _dao.upsert(prior));
    } else if (result.isOk) {
      await _dao.applyEngagement(result.valueOrNull!);
    }
    return result;
  }

  @override
  Future<Result<Reel>> createReel({
    required String videoMediaId,
    required String clientKey,
    String? caption,
    bool commentsDisabled = false,
    String? locationName,
    List<String> taggedUserIds = const [],
  }) async {
    final result = await _remote.create(
      videoMediaId: videoMediaId,
      clientKey: clientKey,
      caption: caption,
      commentsDisabled: commentsDisabled,
      locationName: locationName,
      taggedUserIds: taggedUserIds,
    );
    if (result.isOk) {
      // Optimistic top-of-feed insert; the reel is returned with its video still
      // `processing` (isVideoReady == false → poster placeholder, no playable URL).
      final reel = result.valueOrNull!;
      await _dao.upsert(reel);
      // The video transcodes asynchronously server-side. `GET /reels` is ready-only
      // and never returns this reel until it's ready, so a plain feed refresh can't
      // reconcile it — poll the single-reel endpoint until the video is ready and
      // upsert the canonical copy, letting [watchReelsFeed] flip the UI to playable.
      if (!reel.isVideoReady) {
        unawaited(_reconcileWhenVideoReady(reel.id));
      }
    }
    return result;
  }

  /// Background poll of `GET /reels/:id` after publish until the video finishes
  /// transcoding (or fails), then upsert the canonical reel so the reactive feed
  /// updates itself — no manual pull-to-refresh. Bounded (~60s); transient fetch
  /// errors are retried; the loop is fire-and-forget (never blocks publish).
  Future<void> _reconcileWhenVideoReady(String reelId) async {
    for (var attempt = 0; attempt < pollMaxAttempts; attempt++) {
      await Future<void>.delayed(pollInterval);
      final reel = (await _remote.getReel(reelId)).valueOrNull;
      if (reel == null) continue; // Transient error → keep polling.
      if (reel.isVideoReady || reel.video.status == MediaStatus.failed) {
        await _dao.upsert(reel);
        return;
      }
    }
  }

  @override
  Future<Result<void>> deleteReel(String reelId) async {
    final result = await _remote.delete(reelId);
    if (result.isOk) await _dao.removeById(reelId);
    return result;
  }
}
