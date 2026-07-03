import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/result.dart';

/// The reels data seam (Constitution VIII/IX, B#007 contract). Reads flow through
/// the drift cache as one canonical [Reel] ([watchReelsFeed]/[watchReel]);
/// pagination upserts pages; like/save are optimistic + idempotent and reconcile
/// via [EngagementState]; create is idempotent (`Idempotency-Key`). Every screen
/// consumes this — never HTTP directly. A real impl (`env:['real']`) and an
/// in-memory fake (`env:['fake']`, the one that runs) exist.
abstract interface class ReelsRepository {
  /// Reactive, reverse-chronological canonical reels feed read.
  Stream<List<Reel>> watchReelsFeed();

  /// Reactive read of one canonical cached [Reel] by id. Emits null while the
  /// reel is not cached.
  Stream<Reel?> watchReel(String id);

  /// Load the first page (`GET /reels`), replacing the cached feed.
  Future<Result<CursorPage<Reel>>> loadFirstPage();

  /// Load the next page (`GET /reels?cursor=…`), appending to the cache.
  Future<Result<CursorPage<Reel>>> loadNextPage(String cursor);

  /// Toggle like (idempotent). Reconciles the canonical reel with the returned
  /// engagement counts.
  Future<Result<EngagementState>> toggleLike(
    String reelId, {
    required bool like,
  });

  /// Toggle save/bookmark (idempotent).
  Future<Result<EngagementState>> toggleSave(
    String reelId, {
    required bool save,
  });

  /// Publish a reel from an uploaded [videoMediaId] (idempotent via [clientKey]).
  /// The created reel is optimistically inserted at the top of the cached feed;
  /// while its video is processing it carries `isVideoReady == false`.
  Future<Result<Reel>> createReel({
    required String videoMediaId,
    required String clientKey,
    String? caption,
    bool commentsDisabled,
    String? locationName,
    List<String> taggedUserIds,
  });

  /// Delete the caller's own reel (soft delete server-side); drops it from cache.
  Future<Result<void>> deleteReel(String reelId);

  /// Adjust the cached reel's `commentCount` by [delta]. Owned by the comment
  /// add/delete use cases so the feed and comment surface stay consistent
  /// (Constitution IX). No-op if the reel is not cached.
  Future<void> applyCommentCountDelta(String id, int delta);
}
