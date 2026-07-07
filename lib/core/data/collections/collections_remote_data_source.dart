import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/feed/post.dart' show renditionUrl;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for saved collections (#011) via the shared [ApiClient],
/// reconciled with the shipped **B#011** backend: collections list is a
/// `CursorPage<CollectionDto>`; a `CollectionDto` carries a single derived
/// `cover: MediaDto` (mapped to one cover ref); the saved pile + item listings
/// are `CursorPage<SavedItemDto>` (same kind-tagged shape as `ExploreItem`);
/// add-item / remove-item / delete return `204`. Create carries an
/// `Idempotency-Key`.
@lazySingleton
class CollectionsRemoteDataSource {
  const CollectionsRemoteDataSource(this._api);

  final ApiClient _api;

  /// The caller's named collections (cursor page — the client prepends the
  /// virtual "All saved" default).
  Future<Result<List<SavedCollection>>> listCollections({String? cursor}) =>
      _api.get<List<SavedCollection>>(
        ApiEndpoints.meCollections,
        query: _pageQuery(cursor),
        decode: (data) => CursorPage<SavedCollection>.fromJson(
          (data as Map).cast<String, dynamic>(),
          _collectionFromJson,
        ).items,
      );

  Future<Result<SavedCollection>> getCollection(String id) =>
      _api.get<SavedCollection>(
        ApiEndpoints.collection(id),
        decode: _decodeCollection,
      );

  Future<Result<CursorPage<ExploreItem>>> allSaved({String? cursor}) =>
      _api.get<CursorPage<ExploreItem>>(
        ApiEndpoints.meSaved,
        query: _pageQuery(cursor),
        decode: _decodeItems,
      );

  Future<Result<CursorPage<ExploreItem>>> collectionItems(
    String id, {
    String? cursor,
  }) => _api.get<CursorPage<ExploreItem>>(
    ApiEndpoints.collectionItems(id),
    query: _pageQuery(cursor),
    decode: _decodeItems,
  );

  Future<Result<SavedCollection>> create(
    String name, {
    String? idempotencyKey,
  }) => _api.post<SavedCollection>(
    ApiEndpoints.meCollections,
    body: {'name': name},
    idempotent: true,
    idempotencyKey: idempotencyKey,
    decode: _decodeCollection,
  );

  Future<Result<SavedCollection>> rename(String id, String name) =>
      _api.patch<SavedCollection>(
        ApiEndpoints.collection(id),
        body: {'name': name},
        decode: _decodeCollection,
      );

  Future<Result<void>> delete(String id) =>
      _api.delete<void>(ApiEndpoints.collection(id), decode: (_) {});

  /// Add a post/reel to a collection (`204`; auto-saves it server-side).
  Future<Result<void>> addItem(
    String collectionId,
    String postId, {
    String? idempotencyKey,
  }) => _api.post<void>(
    ApiEndpoints.collectionItems(collectionId),
    body: {'postId': postId},
    idempotent: true,
    idempotencyKey: idempotencyKey,
    decode: (_) {},
  );

  /// Remove a post from a collection (`204`; does not unsave it).
  Future<Result<void>> removeItem(String collectionId, String postId) =>
      _api.delete<void>(
        ApiEndpoints.collectionItem(collectionId, postId),
        decode: (_) {},
      );

  static Map<String, dynamic>? _pageQuery(String? cursor) =>
      cursor == null ? null : {'cursor': cursor};

  static SavedCollection _decodeCollection(dynamic data) =>
      _collectionFromJson((data as Map).cast<String, dynamic>());

  /// Map a B#011 `CollectionDto` (`{id,name,itemCount,cover,createdAt,updatedAt}`)
  /// to the client [SavedCollection]. `cover` is a single `MediaDto`; extract one
  /// thumbnail ref (or none). No `isDefault` on the wire — named collections only.
  static SavedCollection _collectionFromJson(Map<String, dynamic> json) {
    final cover = json['cover'];
    final coverUrl = cover is Map
        ? renditionUrl((cover['variants'] as Map?)?.cast<String, dynamic>())
        : null;
    return SavedCollection(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      coverRefs: coverUrl == null ? const [] : [coverUrl],
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toUtc() ??
          DateTime.utc(2026),
    );
  }

  static CursorPage<ExploreItem> _decodeItems(dynamic data) =>
      CursorPage<ExploreItem>.fromJson(
        (data as Map).cast<String, dynamic>(),
        ExploreItem.fromJson,
      );
}
