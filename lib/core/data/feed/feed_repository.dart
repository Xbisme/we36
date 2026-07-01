import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// The feed data seam (Constitution VIII/IX). Reads flow through the drift cache
/// as one canonical [Post] ([watchHomeFeed]); pagination upserts pages; like/save
/// are optimistic + idempotent and reconcile via [EngagementState]. Every screen
/// consumes this — never HTTP directly. A real impl (`env:['real']`, B#004
/// contract) and an in-memory fake (`env:['fake']`, the one that runs) exist.
abstract interface class FeedRepository {
  /// Reactive, reverse-chronological canonical feed read (FR-001/FR-004).
  Stream<List<Post>> watchHomeFeed();

  /// Load the first page (`GET /feed`), replacing the cached feed (FR-003).
  Future<Result<CursorPage<Post>>> loadFirstPage();

  /// Load the next page (`GET /feed?cursor=…`), appending to the cache (FR-002).
  Future<Result<CursorPage<Post>>> loadNextPage(String cursor);

  /// Toggle like (idempotent). Reconciles the canonical post with the returned
  /// engagement counts (FR-010/FR-012).
  Future<Result<EngagementState>> toggleLike(
    String postId, {
    required bool like,
  });

  /// Toggle save/bookmark (idempotent). No collection selection (FR-014).
  Future<Result<EngagementState>> toggleSave(
    String postId, {
    required bool save,
  });
}
