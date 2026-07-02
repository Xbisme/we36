import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/reels_dao.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Default #008 [ReelsRepository]: a deterministic, contract-shaped reels feed
/// synthesized in memory (no network) and written to the drift cache so reads
/// flow through the same canonical path as the real impl (Constitution
/// VIII/IX/XII). Reels carry no real video/poster URL (offline placeholder, as in
/// #004) — real delivery URLs arrive from the backend via `ReelsRepositoryImpl`.
@LazySingleton(as: ReelsRepository, env: ['fake'])
class FakeReelsRepository implements ReelsRepository {
  FakeReelsRepository(this._db) {
    _master = _synthesize();
  }

  final AppDatabase _db;
  ReelsDao get _dao => _db.reelsDao;

  static const int _total = 12;
  static const int _pageSize = 6;

  late final List<Reel> _master;

  /// Test seam: when true, the next mutation fails once (for rollback tests).
  bool failNextMutation = false;

  /// How long a freshly-created reel stays `processing` before flipping to ready
  /// (simulates transcode; tests set [Duration.zero]).
  Duration processingDelay = const Duration(seconds: 2);

  List<Reel> _synthesize() {
    const authors = ['maya', 'leo', 'ava', 'noah', 'ivy', 'kai'];
    const captions = [
      'trail run at dawn 🏃',
      'studio session',
      'city lights',
      'wave check 🌊',
      'coffee ritual ☕️',
      'golden hour',
    ];
    final base = DateTime.utc(2026, 7, 1, 12);
    return List<Reel>.generate(_total, (i) {
      final username = authors[i % authors.length];
      return Reel(
        id: 'reel-${i.toString().padLeft(3, '0')}',
        author: UserSummary(
          id: 'user-$username',
          username: username,
          displayName: '${username[0].toUpperCase()}${username.substring(1)}',
          isVerified: i.isEven,
        ),
        video: Media(
          id: 'reel-media-$i',
          kind: MediaKind.video,
          status: MediaStatus.ready,
          width: 720,
          height: 1280,
          durationMs: 15000 + i * 1000,
        ),
        hashtags: const [],
        taggedUsers: const [],
        commentsDisabled: false,
        likeCount: 120 + i * 11,
        saveCount: 8 + i,
        commentCount: i % 4,
        viewerHasLiked: false,
        viewerHasSaved: false,
        isVideoReady: true,
        createdAt: base.subtract(Duration(hours: i)),
        caption: captions[i % captions.length],
      );
    });
  }

  CursorPage<Reel> _page(int offset) {
    final slice = _master.skip(offset).take(_pageSize).toList();
    final next = offset + _pageSize;
    final hasMore = next < _master.length;
    return CursorPage<Reel>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  @override
  Stream<List<Reel>> watchReelsFeed() => _dao.watchReelsFeed();

  @override
  Stream<Reel?> watchReel(String id) => _dao.watchReel(id);

  @override
  Future<void> applyCommentCountDelta(String id, int delta) =>
      _dao.adjustCommentCount(id, delta);

  @override
  Future<Result<CursorPage<Reel>>> loadFirstPage() async {
    final page = _page(0);
    await _dao.clearFeed();
    await _dao.upsertAll(page.items);
    return Result<CursorPage<Reel>>.ok(page);
  }

  @override
  Future<Result<CursorPage<Reel>>> loadNextPage(String cursor) async {
    final offset = int.tryParse(cursor) ?? _master.length;
    final page = _page(offset);
    await _dao.upsertAll(page.items);
    return Result<CursorPage<Reel>>.ok(page);
  }

  @override
  Future<Result<EngagementState>> toggleLike(
    String reelId, {
    required bool like,
  }) => _mutate(reelId, like: like);

  @override
  Future<Result<EngagementState>> toggleSave(
    String reelId, {
    required bool save,
  }) => _mutate(reelId, save: save);

  Future<Result<EngagementState>> _mutate(
    String reelId, {
    bool? like,
    bool? save,
  }) async {
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<EngagementState>.err(AppFailure.networkError());
    }
    final idx = _master.indexWhere((r) => r.id == reelId);
    if (idx < 0) {
      return const Result<EngagementState>.err(AppFailure.notFound());
    }
    final prior = _master[idx];
    final nextLiked = like ?? prior.viewerHasLiked;
    final nextSaved = save ?? prior.viewerHasSaved;
    final likeDelta = (nextLiked ? 1 : 0) - (prior.viewerHasLiked ? 1 : 0);
    final saveDelta = (nextSaved ? 1 : 0) - (prior.viewerHasSaved ? 1 : 0);
    final optimistic = prior.copyWith(
      viewerHasLiked: nextLiked,
      viewerHasSaved: nextSaved,
      likeCount: prior.likeCount + likeDelta,
      saveCount: prior.saveCount + saveDelta,
    );
    // Optimistic write — reflected instantly via watchReelsFeed (Constitution IX).
    await _dao.upsert(optimistic);
    _master[idx] = optimistic;
    final engagement = EngagementState(
      postId: reelId,
      likeCount: optimistic.likeCount,
      saveCount: optimistic.saveCount,
      viewerHasLiked: optimistic.viewerHasLiked,
      viewerHasSaved: optimistic.viewerHasSaved,
    );
    await _dao.applyEngagement(engagement);
    return Result<EngagementState>.ok(engagement);
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
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<Reel>.err(AppFailure.uploadFailed());
    }
    // Idempotent: a retry with the same key returns the existing reel.
    final existingIdx = _master.indexWhere((r) => r.id == 'reel-$clientKey');
    if (existingIdx >= 0) {
      return Result<Reel>.ok(_master[existingIdx]);
    }
    final reel = Reel(
      id: 'reel-$clientKey',
      author: const UserSummary(
        id: 'user-you',
        username: 'you',
        displayName: 'You',
        isVerified: false,
      ),
      video: Media(
        id: videoMediaId,
        kind: MediaKind.video,
        status: MediaStatus.processing,
        width: 720,
        height: 1280,
      ),
      hashtags: const [],
      taggedUsers: const [],
      commentsDisabled: commentsDisabled,
      likeCount: 0,
      saveCount: 0,
      commentCount: 0,
      viewerHasLiked: false,
      viewerHasSaved: false,
      isVideoReady: false,
      createdAt: DateTime.now().toUtc(),
      caption: caption,
      location: locationName == null
          ? null
          : Place(id: 'place-$clientKey', name: locationName),
    );
    _master.insert(0, reel);
    await _dao.upsert(reel); // optimistic top-of-feed insert (processing)
    // Simulate transcode completing → flip to ready (reconciled via the stream).
    Future<void>.delayed(processingDelay, () async {
      final i = _master.indexWhere((r) => r.id == reel.id);
      if (i < 0) return;
      final ready = _master[i].copyWith(
        isVideoReady: true,
        video: _master[i].video.copyWith(status: MediaStatus.ready),
      );
      _master[i] = ready;
      await _dao.upsert(ready);
    });
    return Result<Reel>.ok(reel);
  }

  @override
  Future<Result<void>> deleteReel(String reelId) async {
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<void>.err(AppFailure.networkError());
    }
    _master.removeWhere((r) => r.id == reelId);
    await _dao.removeById(reelId);
    return const Result<void>.ok(null);
  }
}
