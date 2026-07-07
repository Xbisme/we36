import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/domain/result.dart';

/// Create a named collection (#011 US1/US4) — optimistically reflected through the
/// reactive collections cache. Names need not be unique.
@injectable
class CreateCollection {
  const CreateCollection(this._repo);
  final CollectionsRepository _repo;

  Future<Result<SavedCollection>> call(String name, {String? idempotencyKey}) =>
      _repo.create(name, idempotencyKey: idempotencyKey);
}

/// Rename a named collection (#011 US4).
@injectable
class RenameCollection {
  const RenameCollection(this._repo);
  final CollectionsRepository _repo;

  Future<Result<SavedCollection>> call(String id, String name) =>
      _repo.rename(id, name);
}

/// Delete a named collection (#011 US4) — its posts stay saved (SC-006).
@injectable
class DeleteCollection {
  const DeleteCollection(this._repo);
  final CollectionsRepository _repo;

  Future<Result<void>> call(String id) => _repo.delete(id);
}

/// Set a named collection's cover to a saved item (#011 US4).
@injectable
class SetCollectionCover {
  const SetCollectionCover(this._repo);
  final CollectionsRepository _repo;

  Future<Result<SavedCollection>> call(String id, String coverItemId) =>
      _repo.setCover(id, coverItemId);
}
