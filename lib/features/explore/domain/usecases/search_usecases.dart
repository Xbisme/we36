import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Search use cases (#009 US1; Constitution III — inject use cases into cubits,
/// not repos). Thin, testable seams over [DiscoveryRepository].

/// The fixed blended `top` snapshot for a term (no pagination).
@injectable
class SearchTopQuery {
  const SearchTopQuery(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<SearchTop>> call(String q) => _repo.searchTop(q);
}

/// A cursor page of account results.
@injectable
class SearchAccounts {
  const SearchAccounts(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<CursorPage<AccountResult>>> call(String q, {String? cursor}) =>
      _repo.searchAccounts(q, cursor: cursor);
}

/// A cursor page of hashtag results.
@injectable
class SearchTags {
  const SearchTags(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<CursorPage<HashtagResult>>> call(String q, {String? cursor}) =>
      _repo.searchTags(q, cursor: cursor);
}

/// A cursor page of place results.
@injectable
class SearchPlaces {
  const SearchPlaces(this._repo);
  final DiscoveryRepository _repo;
  Future<Result<CursorPage<PlaceResult>>> call(String q, {String? cursor}) =>
      _repo.searchPlaces(q, cursor: cursor);
}
