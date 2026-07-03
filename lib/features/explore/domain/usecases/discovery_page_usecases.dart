import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/discovery_page.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Hashtag/place page use cases (#009 US4; Constitution III). Thin seams over
/// [DiscoveryRepository].

@injectable
class LoadHashtagPage {
  const LoadHashtagPage(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<HashtagPage>> call(String tag, {String? cursor}) =>
      _repo.hashtagPage(tag, cursor: cursor);
}

@injectable
class LoadPlacePage {
  const LoadPlacePage(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<PlacePage>> call(String id, {String? cursor}) =>
      _repo.placePage(id, cursor: cursor);
}
