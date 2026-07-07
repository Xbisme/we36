import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/saved_collections_dao.dart';
import 'package:we36/core/data/collections/collections_remote_data_source.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Real [CollectionsRepository] (`env:['real']`, reconciled with the shipped
/// **B#011**). The collections list is read reactively from the drift
/// `SavedCollections` cache (one canonical copy, Constitution IX); mutations hit
/// the backend then reconcile the cache. The canonical **saved flag** stays
/// `Post.viewerHasSaved` — [unsave] delegates to [FeedRepository]. Item grids are
/// live cursor pages. The backend derives covers (no set-cover) and exposes no
/// per-post membership endpoint (the picker files additively).
@LazySingleton(as: CollectionsRepository, env: ['real'])
class CollectionsRepositoryImpl implements CollectionsRepository {
  CollectionsRepositoryImpl(this._remote, this._db, this._feed);

  final CollectionsRemoteDataSource _remote;
  final AppDatabase _db;
  final FeedRepository _feed;

  SavedCollectionsDao get _dao => _db.savedCollectionsDao;

  @override
  Stream<List<SavedCollection>> watchCollections() => _dao.watchCollections();

  @override
  Future<Result<void>> refreshCollections() async {
    final listRes = await _remote.listCollections();
    if (listRes.isErr) return Result<void>.err(listRes.failureOrNull!);
    // Best-effort saved count for the virtual "All saved" default (its first
    // page; the backend's saved pile carries no total). > 0 so the Saved screen
    // does not fall into the fully-empty state when posts are saved.
    final savedRes = await _remote.allSaved();
    final savedCount = savedRes.valueOrNull?.items.length ?? 0;
    final all = SavedCollection(
      id: kAllSavedCollectionId,
      name: 'All saved',
      itemCount: savedCount,
      isDefault: true,
      updatedAt: DateTime.utc(2026),
    );
    await _dao.replaceAll([all, ...listRes.valueOrNull!]);
    return const Result<void>.ok(null);
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> collectionItems(
    String id, {
    String? cursor,
  }) => _remote.collectionItems(id, cursor: cursor);

  @override
  Future<Result<CursorPage<ExploreItem>>> allSaved({String? cursor}) =>
      _remote.allSaved(cursor: cursor);

  @override
  Future<Result<PostCollectionsMembership>> membership(String postId) async {
    // No per-post membership endpoint on B#011 — return the collections as an
    // additive picker (checkmarks unknown → false). Filing is idempotent.
    final listRes = await _remote.listCollections();
    if (listRes.isErr) return Result.err(listRes.failureOrNull!);
    return Result.ok(
      PostCollectionsMembership(
        postId: postId,
        isSaved: true,
        collections: [
          for (final c in listRes.valueOrNull!)
            CollectionPickerRow(collection: c, contains: false),
        ],
      ),
    );
  }

  @override
  Future<Result<SavedCollection>> create(
    String name, {
    String? idempotencyKey,
  }) async {
    final res = await _remote.create(name, idempotencyKey: idempotencyKey);
    if (res.isOk) unawaited(refreshCollections());
    return res;
  }

  @override
  Future<Result<SavedCollection>> rename(String id, String name) async {
    final res = await _remote.rename(id, name);
    if (res.isOk) unawaited(refreshCollections());
    return res;
  }

  @override
  Future<Result<SavedCollection>> setCover(
    String id,
    String coverItemId,
  ) async {
    // B#011 derives the cover automatically — there is no set-cover endpoint.
    return const Result.err(AppFailure.serverError());
  }

  @override
  Future<Result<void>> delete(String id) async {
    final res = await _remote.delete(id);
    if (res.isOk) await _dao.deleteById(id);
    return res;
  }

  @override
  Future<Result<SavedCollection>> file(
    String collectionId,
    String postId, {
    String? idempotencyKey,
  }) async {
    final res = await _remote.addItem(
      collectionId,
      postId,
      idempotencyKey: idempotencyKey,
    );
    if (res.isErr) return Result.err(res.failureOrNull!);
    unawaited(refreshCollections());
    // The add returns 204 → re-fetch the collection for the updated count/cover.
    return _remote.getCollection(collectionId);
  }

  @override
  Future<Result<SavedCollection>> unfile(
    String collectionId,
    String postId,
  ) async {
    final res = await _remote.removeItem(collectionId, postId);
    if (res.isErr) return Result.err(res.failureOrNull!);
    unawaited(refreshCollections());
    return _remote.getCollection(collectionId);
  }

  @override
  Future<Result<void>> unsave(String postId) async {
    final res = await _feed.toggleSave(postId, save: false);
    if (res.isErr) return Result<void>.err(res.failureOrNull!);
    unawaited(refreshCollections());
    return const Result<void>.ok(null);
  }
}
