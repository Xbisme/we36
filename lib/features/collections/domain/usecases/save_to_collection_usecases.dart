import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/domain/result.dart';

/// Load a post's membership across collections (#011 US2) — powers the picker
/// checkmarks + the full-unsave confirm gate.
@injectable
class LoadPicker {
  const LoadPicker(this._repo);
  final CollectionsRepository _repo;

  Future<Result<PostCollectionsMembership>> call(String postId) =>
      _repo.membership(postId);
}

/// File a post into a collection (#011 US2) — also saves it if it wasn't.
@injectable
class FileIntoCollection {
  const FileIntoCollection(this._repo);
  final CollectionsRepository _repo;

  Future<Result<SavedCollection>> call(
    String collectionId,
    String postId, {
    String? idempotencyKey,
  }) => _repo.file(collectionId, postId, idempotencyKey: idempotencyKey);
}

/// Remove a post from a collection (#011 US2/US3) — stays saved elsewhere.
@injectable
class UnfileFromCollection {
  const UnfileFromCollection(this._repo);
  final CollectionsRepository _repo;

  Future<Result<SavedCollection>> call(String collectionId, String postId) =>
      _repo.unfile(collectionId, postId);
}
