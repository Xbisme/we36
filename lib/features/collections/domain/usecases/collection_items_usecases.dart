import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Load one page of a collection's items (#011 US3) — the virtual "All saved"
/// view (`id == kAllSavedCollectionId`) or a named collection.
@injectable
class LoadCollectionItems {
  const LoadCollectionItems(this._repo);
  final CollectionsRepository _repo;

  Future<Result<CursorPage<ExploreItem>>> call(String id, {String? cursor}) =>
      id == kAllSavedCollectionId
      ? _repo.allSaved(cursor: cursor)
      : _repo.collectionItems(id, cursor: cursor);
}

/// Fully unsave a post (#011 US3) — cascades: removed from every collection and
/// from "All saved"; the canonical `viewerHasSaved` flips false everywhere.
@injectable
class FullUnsave {
  const FullUnsave(this._repo);
  final CollectionsRepository _repo;

  Future<Result<void>> call(String postId) => _repo.unsave(postId);
}
