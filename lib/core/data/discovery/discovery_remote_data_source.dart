import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/discovery/discovery_page.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for discovery (#009, B#009): explore grid, search (Top + typed),
/// hashtag/place pages, recents. All via the shared [ApiClient] (centralized
/// auth/refresh/error mapping → `Result`).
@lazySingleton
class DiscoveryRemoteDataSource {
  const DiscoveryRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<CursorPage<ExploreItem>>> getExplore(PageRequest request) =>
      _api.get<CursorPage<ExploreItem>>(
        ApiEndpoints.explore,
        query: request.toQuery(),
        decode: (data) => CursorPage<ExploreItem>.fromJson(
          data as Map<String, dynamic>,
          ExploreItem.fromJson,
        ),
      );

  Future<Result<SearchTop>> searchTop(String q) => _api.get<SearchTop>(
    ApiEndpoints.search,
    query: {'q': q, 'type': 'top'},
    decode: (data) => SearchTop.fromJson(data as Map<String, dynamic>),
  );

  Future<Result<CursorPage<AccountResult>>> searchAccounts(
    String q, {
    String? cursor,
  }) => _searchPage<AccountResult>('accounts', q, cursor, AccountResult.fromJson);

  Future<Result<CursorPage<HashtagResult>>> searchTags(
    String q, {
    String? cursor,
  }) => _searchPage<HashtagResult>('tags', q, cursor, HashtagResult.fromJson);

  Future<Result<CursorPage<PlaceResult>>> searchPlaces(
    String q, {
    String? cursor,
  }) => _searchPage<PlaceResult>('places', q, cursor, PlaceResult.fromJson);

  Future<Result<CursorPage<T>>> _searchPage<T>(
    String type,
    String q,
    String? cursor,
    T Function(Map<String, dynamic>) itemFromJson,
  ) => _api.get<CursorPage<T>>(
    ApiEndpoints.search,
    query: {'q': q, 'type': type, 'cursor': ?cursor},
    decode: (data) =>
        CursorPage<T>.fromJson(data as Map<String, dynamic>, itemFromJson),
  );

  Future<Result<HashtagPage>> hashtagPage(String tag, {String? cursor}) =>
      _api.get<HashtagPage>(
        ApiEndpoints.hashtagPage(tag),
        query: PageRequest(cursor: cursor).toQuery(),
        decode: (data) => HashtagPage.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<PlacePage>> placePage(String id, {String? cursor}) =>
      _api.get<PlacePage>(
        ApiEndpoints.placePage(id),
        query: PageRequest(cursor: cursor).toQuery(),
        decode: (data) => PlacePage.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<List<SearchRecent>>> recents() => _api.get<List<SearchRecent>>(
    ApiEndpoints.searchRecents,
    decode: (data) {
      final items = (data as Map<String, dynamic>)['items'];
      if (items is! List) return const <SearchRecent>[];
      return [
        for (final e in items)
          if (e is Map<String, dynamic>) SearchRecent.fromJson(e),
      ];
    },
  );

  Future<Result<SearchRecent>> recordRecent(RecordSearchRecent record) =>
      _api.post<SearchRecent>(
        ApiEndpoints.searchRecents,
        body: record.toJson(),
        decode: (data) => SearchRecent.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> deleteRecent(String id) =>
      _api.delete<void>(ApiEndpoints.searchRecent(id), decode: (_) {});

  Future<Result<void>> clearRecents() =>
      _api.delete<void>(ApiEndpoints.searchRecents, decode: (_) {});
}
