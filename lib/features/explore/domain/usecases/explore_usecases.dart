import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Explore grid use cases (#009 US2; Constitution III). Thin seams over
/// [DiscoveryRepository].

/// Reactive canonical Explore grid read (drift stream).
@injectable
class WatchExplore {
  const WatchExplore(this._repo);
  final DiscoveryRepository _repo;
  Stream<List<ExploreItem>> call() => _repo.watchExplore();
}

/// Load the first page (also used for pull-to-refresh); replaces the cache.
@injectable
class LoadExploreFirst {
  const LoadExploreFirst(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<CursorPage<ExploreItem>>> call() => _repo.loadExploreFirst();
}

/// Append the next page for the given cursor.
@injectable
class LoadExploreNext {
  const LoadExploreNext(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<CursorPage<ExploreItem>>> call(String cursor) =>
      _repo.loadExploreNext(cursor);
}
