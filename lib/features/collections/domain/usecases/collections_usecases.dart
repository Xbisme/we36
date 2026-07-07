import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/domain/result.dart';

/// Reactive read of the person's saved collections (#011 US1) — the one canonical
/// list from the drift cache, "All saved" first. Renders offline-from-cache.
@injectable
class WatchCollections {
  const WatchCollections(this._repo);
  final CollectionsRepository _repo;

  Stream<List<SavedCollection>> call() => _repo.watchCollections();
}

/// Reconcile the cached collections list with the server (background refresh).
@injectable
class LoadCollections {
  const LoadCollections(this._repo);
  final CollectionsRepository _repo;

  Future<Result<void>> call() => _repo.refreshCollections();
}
