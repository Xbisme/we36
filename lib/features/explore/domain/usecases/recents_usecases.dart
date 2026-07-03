import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/domain/result.dart';

/// Recent-search use cases (#009 US3; Constitution III). Thin seams over
/// [DiscoveryRepository].

@injectable
class GetRecents {
  const GetRecents(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<List<SearchRecent>>> call() => _repo.recents();
}

@injectable
class RecordRecent {
  const RecordRecent(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<SearchRecent>> call(RecordSearchRecent record) =>
      _repo.recordRecent(record);
}

@injectable
class DeleteRecent {
  const DeleteRecent(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<void>> call(String id) => _repo.deleteRecent(id);
}

@injectable
class ClearRecents {
  const ClearRecents(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<void>> call() => _repo.clearRecents();
}
