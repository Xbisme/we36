import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// The saved-collections data seam (#011, B#011 contract; Constitution VIII/IX).
/// Screens consume this via use cases — never HTTP directly. A real impl
/// (`env:['real']`) and an in-memory fake (`env:['fake']`, the one that runs)
/// exist. The collections list is the one canonical collections copy (reactive
/// drift cache); item grids are live cursor pages. The canonical **saved flag**
/// stays `Post.viewerHasSaved` (#004) — [unsave] delegates to the feed seam.
abstract interface class CollectionsRepository {
  /// Reactive collections list (default "All saved" first) — the render source
  /// for the Saved grid. Cache-first (renders offline, FR-012).
  Stream<List<SavedCollection>> watchCollections();

  /// Reconcile the cached list with the server (`GET /me/collections` + the saved
  /// count for the default). Errors surface without clearing the cache.
  Future<Result<void>> refreshCollections();

  /// One named collection's saved items (`GET /me/collections/{id}/items`,
  /// cursor). Reels are marked in the `ExploreItem`.
  Future<Result<CursorPage<ExploreItem>>> collectionItems(
    String id, {
    String? cursor,
  });

  /// The virtual "All saved" view (`GET /me/saved`, cursor) — every saved item.
  Future<Result<CursorPage<ExploreItem>>> allSaved({String? cursor});

  /// A post's membership across named collections (`GET /me/saved/{postId}/
  /// collections`) — powers the picker + the full-unsave confirm gate (R4).
  Future<Result<PostCollectionsMembership>> membership(String postId);

  /// Create a named collection (`POST /me/collections`). Names need not be
  /// unique. Idempotent via [idempotencyKey].
  Future<Result<SavedCollection>> create(
    String name, {
    String? idempotencyKey,
  });

  /// Rename a named collection (`PATCH /me/collections/{id}`).
  Future<Result<SavedCollection>> rename(String id, String name);

  /// Set a named collection's cover to a saved item (`PATCH /me/collections/{id}`).
  Future<Result<SavedCollection>> setCover(String id, String coverItemId);

  /// Delete a named collection (`DELETE /me/collections/{id}`) — its posts stay
  /// saved in "All saved" (SC-006). No-op if absent.
  Future<Result<void>> delete(String id);

  /// File a post into a collection (`POST /me/collections/{id}/items/{postId}`).
  /// If the post was not saved, this also sets the canonical saved flag.
  /// Idempotent via [idempotencyKey]; returns the updated collection.
  Future<Result<SavedCollection>> file(
    String collectionId,
    String postId, {
    String? idempotencyKey,
  });

  /// Remove a post from a collection (`DELETE /me/collections/{id}/items/{postId}`)
  /// — the post stays saved elsewhere + in "All saved".
  Future<Result<SavedCollection>> unfile(String collectionId, String postId);

  /// Fully unsave a post (canonical `DELETE /posts/{id}/save`, #004) — cascades:
  /// removed from every collection and from "All saved"; `viewerHasSaved=false`.
  Future<Result<void>> unsave(String postId);
}
