import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/explore_dao.dart';
import 'package:we36/core/data/discovery/discovery_page.dart';
import 'package:we36/core/data/discovery/discovery_remote_data_source.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Real discovery repository (#009, B#009). The Explore grid is reconciled into
/// the drift cache (one canonical ordered snapshot, reactive reads) so it opens
/// offline on a cold start; search, hashtag/place pages, and recents are
/// live-query pass-throughs (the cubits own optimistic recents). Registered only
/// in the `real` environment — the in-memory fake runs until the dev backend is
/// wired.
@LazySingleton(as: DiscoveryRepository, env: ['real'])
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  DiscoveryRepositoryImpl(this._remote, this._db);

  final DiscoveryRemoteDataSource _remote;
  final AppDatabase _db;

  ExploreDao get _dao => _db.exploreDao;

  @override
  Stream<List<ExploreItem>> watchExplore() => _dao.watchExplore();

  @override
  Future<Result<CursorPage<ExploreItem>>> loadExploreFirst() async {
    final result = await _remote.getExplore(PageRequest());
    if (result.isOk) {
      // Replace the cached snapshot only after a successful fetch — a failed
      // refresh keeps the existing cache (offline-from-cache).
      await _dao.replaceAll(result.valueOrNull!.items);
    }
    return result;
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> loadExploreNext(String cursor) async {
    final result = await _remote.getExplore(PageRequest(cursor: cursor));
    if (result.isOk) {
      final from = await _dao.count();
      await _dao.appendAll(result.valueOrNull!.items, fromIndex: from);
    }
    return result;
  }

  @override
  Future<Result<SearchTop>> searchTop(String q) => _remote.searchTop(q);

  @override
  Future<Result<CursorPage<AccountResult>>> searchAccounts(
    String q, {
    String? cursor,
  }) => _remote.searchAccounts(q, cursor: cursor);

  @override
  Future<Result<CursorPage<HashtagResult>>> searchTags(
    String q, {
    String? cursor,
  }) => _remote.searchTags(q, cursor: cursor);

  @override
  Future<Result<CursorPage<PlaceResult>>> searchPlaces(
    String q, {
    String? cursor,
  }) => _remote.searchPlaces(q, cursor: cursor);

  @override
  Future<Result<HashtagPage>> hashtagPage(String tag, {String? cursor}) =>
      _remote.hashtagPage(tag, cursor: cursor);

  @override
  Future<Result<PlacePage>> placePage(String id, {String? cursor}) =>
      _remote.placePage(id, cursor: cursor);

  @override
  Future<Result<List<SearchRecent>>> recents() => _remote.recents();

  @override
  Future<Result<SearchRecent>> recordRecent(RecordSearchRecent record) =>
      _remote.recordRecent(record);

  @override
  Future<Result<void>> deleteRecent(String id) => _remote.deleteRecent(id);

  @override
  Future<Result<void>> clearRecents() => _remote.clearRecents();
}
