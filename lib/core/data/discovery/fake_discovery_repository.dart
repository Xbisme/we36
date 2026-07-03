import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/explore_dao.dart';
import 'package:we36/core/data/discovery/discovery_page.dart';
import 'package:we36/core/data/discovery/discovery_repository.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Default #009 [DiscoveryRepository]: a deterministic, contract-shaped discovery
/// surface synthesized in memory (no network). The Explore grid is written to the
/// drift cache so reads flow through the same canonical path as the real impl
/// (Constitution VIII/IX/XII). Search honors block/private rules (blocked accounts
/// never appear; a private account is findable by handle). Recents are
/// dedupe-and-promote in memory.
@LazySingleton(as: DiscoveryRepository, env: ['fake'])
class FakeDiscoveryRepository implements DiscoveryRepository {
  FakeDiscoveryRepository(this._db) {
    _explore = _synthesizeExplore();
    _accounts = _synthesizeAccounts();
  }

  final AppDatabase _db;
  ExploreDao get _dao => _db.exploreDao;

  static const int _explorePageSize = 6;

  late final List<ExploreItem> _explore;
  late final List<AccountResult> _accounts;
  final List<SearchRecent> _recents = [];
  int _recentSeq = 0;

  /// Test seam: when true, the next query fails once.
  bool failNextQuery = false;

  /// Test seam: when true, the next mutation (record/delete/clear) fails once.
  bool failNextMutation = false;

  /// Usernames the viewer blocks / is blocked by — never surfaced in search.
  static const Set<String> _blocked = {'blocked_user'};

  // ── Synthesis ───────────────────────────────────────────────────────────────

  List<ExploreItem> _synthesizeExplore() {
    const authors = ['maya', 'leo', 'ava', 'noah', 'ivy', 'kai'];
    final base = DateTime.utc(2026, 7, 1, 12);
    return List<ExploreItem>.generate(18, (i) {
      final username = authors[i % authors.length];
      final author = UserSummary(
        id: 'user-$username',
        username: username,
        displayName: _cap(username),
        isVerified: i.isEven,
      );
      final createdAt = base.subtract(Duration(hours: i));
      // Every 3rd cell is a reel; the rest are photo posts.
      if (i % 3 == 2) {
        return ExploreItem(
          kind: ExploreItemKind.reel,
          reel: Reel(
            id: 'explore-reel-$i',
            author: author,
            video: Media(
              id: 'explore-reel-media-$i',
              kind: MediaKind.video,
              status: MediaStatus.ready,
              width: 720,
              height: 1280,
            ),
            hashtags: const [],
            taggedUsers: const [],
            commentsDisabled: false,
            likeCount: 200 + i * 7,
            saveCount: 10 + i,
            commentCount: i % 5,
            viewerHasLiked: false,
            viewerHasSaved: false,
            isVideoReady: true,
            createdAt: createdAt,
          ),
        );
      }
      return ExploreItem(
        kind: ExploreItemKind.post,
        post: Post(
          id: 'explore-post-$i',
          author: author,
          media: [
            PostMedia(
              position: 0,
              media: Media(
                id: 'explore-post-media-$i',
                kind: MediaKind.image,
                status: MediaStatus.ready,
                width: 1080,
                height: 1350,
              ),
            ),
          ],
          hashtags: const [],
          taggedUsers: const [],
          commentsDisabled: false,
          likeCount: 90 + i * 5,
          saveCount: 4 + i,
          commentCount: i % 4,
          viewerHasLiked: false,
          viewerHasSaved: false,
          createdAt: createdAt,
        ),
      );
    });
  }

  List<AccountResult> _synthesizeAccounts() {
    // (username, displayName, following, requested, private)
    const seed = [
      ('alice_travel', 'Alice Travel', false, false, false),
      ('alicia_makes', 'Alicia Makes', true, false, false),
      ('bob_private', 'Bob', false, true, true),
      ('maya', 'Maya', true, false, false),
      ('leo', 'Leo', false, false, false),
      ('ava', 'Ava', false, false, false),
      ('noah', 'Noah', false, false, false),
      ('blocked_user', 'Blocked', false, false, false),
    ];
    return [
      for (final (username, name, following, requested, _) in seed)
        AccountResult(
          user: UserSummary(
            id: 'user-$username',
            username: username,
            displayName: name,
            isVerified: false,
          ),
          relationship: ViewerRelationship(
            following: following,
            requested: requested,
            followsYou: false,
            blocking: false,
          ),
        ),
    ];
  }

  static const List<HashtagResult> _hashtags = [
    HashtagResult(tag: 'sunset', postCount: 1240),
    HashtagResult(tag: 'sunrise', postCount: 830),
    HashtagResult(tag: 'travel', postCount: 98000),
    HashtagResult(tag: 'food', postCount: 45000),
    HashtagResult(tag: 'design', postCount: 22000),
    HashtagResult(tag: 'fitness', postCount: 31000),
    HashtagResult(tag: 'goldenhour', postCount: 1200000),
  ];

  static const List<PlaceResult> _places = [
    PlaceResult(
      id: 'place-sunset-beach',
      name: 'Sunset Beach',
      lat: 21,
      lng: 105,
    ),
    PlaceResult(id: 'place-sun-valley', name: 'Sun Valley', lat: 43, lng: -114),
    PlaceResult(id: 'place-da-nang', name: 'Da Nang', lat: 16, lng: 108),
  ];

  // ── Explore grid ────────────────────────────────────────────────────────────

  @override
  Stream<List<ExploreItem>> watchExplore() => _dao.watchExplore();

  @override
  Future<Result<CursorPage<ExploreItem>>> loadExploreFirst() async {
    if (_takeFailQuery()) {
      return const Result<CursorPage<ExploreItem>>.err(
        AppFailure.networkError(),
      );
    }
    final page = _explorePage(0);
    await _dao.replaceAll(page.items);
    return Result<CursorPage<ExploreItem>>.ok(page);
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> loadExploreNext(String cursor) async {
    if (_takeFailQuery()) {
      return const Result<CursorPage<ExploreItem>>.err(
        AppFailure.networkError(),
      );
    }
    final offset = int.tryParse(cursor) ?? _explore.length;
    final page = _explorePage(offset);
    await _dao.appendAll(page.items, fromIndex: offset);
    return Result<CursorPage<ExploreItem>>.ok(page);
  }

  CursorPage<ExploreItem> _explorePage(int offset) {
    final slice = _explore.skip(offset).take(_explorePageSize).toList();
    final next = offset + _explorePageSize;
    final hasMore = next < _explore.length;
    return CursorPage<ExploreItem>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  // ── Search ──────────────────────────────────────────────────────────────────

  @override
  Future<Result<SearchTop>> searchTop(String q) async {
    if (_takeFailQuery()) {
      return const Result<SearchTop>.err(AppFailure.networkError());
    }
    return Result<SearchTop>.ok(
      SearchTop(
        accounts: _matchAccounts(q).take(3).toList(),
        hashtags: _matchHashtags(q).take(3).toList(),
        places: _matchPlaces(q).take(3).toList(),
      ),
    );
  }

  @override
  Future<Result<CursorPage<AccountResult>>> searchAccounts(
    String q, {
    String? cursor,
  }) async => _pageOf(_matchAccounts(q), cursor);

  @override
  Future<Result<CursorPage<HashtagResult>>> searchTags(
    String q, {
    String? cursor,
  }) async => _pageOf(_matchHashtags(q), cursor);

  @override
  Future<Result<CursorPage<PlaceResult>>> searchPlaces(
    String q, {
    String? cursor,
  }) async => _pageOf(_matchPlaces(q), cursor);

  List<AccountResult> _matchAccounts(String q) {
    final n = _norm(q);
    return _accounts
        .where((a) => !_blocked.contains(a.user.username))
        .where(
          (a) =>
              _norm(a.user.username ?? '').contains(n) ||
              _norm(a.user.displayName ?? '').contains(n),
        )
        .toList();
  }

  List<HashtagResult> _matchHashtags(String q) {
    final n = _norm(q);
    return _hashtags.where((h) => _norm(h.tag).contains(n)).toList();
  }

  List<PlaceResult> _matchPlaces(String q) {
    final n = _norm(q);
    return _places.where((p) => _norm(p.name).contains(n)).toList();
  }

  Result<CursorPage<T>> _pageOf<T>(List<T> all, String? cursor) {
    if (_takeFailQuery()) {
      return Result<CursorPage<T>>.err(const AppFailure.networkError());
    }
    const size = 10;
    final offset = int.tryParse(cursor ?? '0') ?? 0;
    final slice = all.skip(offset).take(size).toList();
    final next = offset + size;
    final hasMore = next < all.length;
    return Result<CursorPage<T>>.ok(
      CursorPage<T>(
        items: slice,
        nextCursor: hasMore ? '$next' : null,
        hasMore: hasMore,
      ),
    );
  }

  // ── Hashtag / place pages ─────────────────────────────────────────────────────

  @override
  Future<Result<HashtagPage>> hashtagPage(String tag, {String? cursor}) async {
    if (_takeFailQuery()) {
      return const Result<HashtagPage>.err(AppFailure.networkError());
    }
    final match = _hashtags.firstWhere(
      (h) => h.tag == tag,
      orElse: () => HashtagResult(tag: tag, postCount: _explore.length),
    );
    final offset = int.tryParse(cursor ?? '0') ?? 0;
    return Result<HashtagPage>.ok(
      HashtagPage(
        tag: match.tag,
        postCount: match.postCount,
        page: _explorePage(offset),
      ),
    );
  }

  @override
  Future<Result<PlacePage>> placePage(String id, {String? cursor}) async {
    if (_takeFailQuery()) {
      return const Result<PlacePage>.err(AppFailure.networkError());
    }
    final match = _places.firstWhere(
      (p) => p.id == id,
      orElse: () => PlaceResult(id: id, name: 'Place'),
    );
    final offset = int.tryParse(cursor ?? '0') ?? 0;
    return Result<PlacePage>.ok(
      PlacePage(
        id: match.id,
        name: match.name,
        lat: match.lat,
        lng: match.lng,
        postCount: _explore.length,
        page: _explorePage(offset),
      ),
    );
  }

  // ── Recents (dedupe-and-promote) ──────────────────────────────────────────────

  @override
  Future<Result<List<SearchRecent>>> recents() async {
    if (_takeFailQuery()) {
      return const Result<List<SearchRecent>>.err(AppFailure.networkError());
    }
    return Result<List<SearchRecent>>.ok(List.unmodifiable(_recents));
  }

  @override
  Future<Result<SearchRecent>> recordRecent(RecordSearchRecent record) async {
    if (_takeFailMutation()) {
      return const Result<SearchRecent>.err(AppFailure.networkError());
    }
    final key = _recentKey(record);
    final entry = _resolve(record);
    // Dedupe-and-promote: drop any existing entry for this target, insert on top.
    _recents
      ..removeWhere((r) => _recentKeyOf(r) == key)
      ..insert(0, entry);
    return Result<SearchRecent>.ok(entry);
  }

  @override
  Future<Result<void>> deleteRecent(String id) async {
    if (_takeFailMutation()) {
      return const Result<void>.err(AppFailure.networkError());
    }
    _recents.removeWhere((r) => r.id == id);
    return const Result<void>.ok(null);
  }

  @override
  Future<Result<void>> clearRecents() async {
    if (_takeFailMutation()) {
      return const Result<void>.err(AppFailure.networkError());
    }
    _recents.clear();
    return const Result<void>.ok(null);
  }

  SearchRecent _resolve(RecordSearchRecent r) {
    final id = 'recent-${_recentSeq++}';
    final at = DateTime.utc(2026, 7, 3).add(Duration(seconds: _recentSeq));
    switch (r.type) {
      case SearchRecentType.term:
        return SearchRecent(id: id, type: r.type, recordedAt: at, term: r.term);
      case SearchRecentType.account:
        final acc = _accounts.firstWhere(
          (a) => a.user.id == r.targetUserId,
          orElse: () => _accounts.first,
        );
        return SearchRecent(
          id: id,
          type: r.type,
          recordedAt: at,
          account: acc.user,
        );
      case SearchRecentType.hashtag:
        return SearchRecent(
          id: id,
          type: r.type,
          recordedAt: at,
          hashtag: _hashtags.firstWhere(
            (h) => h.tag == r.tag,
            orElse: () => HashtagResult(tag: r.tag ?? '', postCount: 0),
          ),
        );
      case SearchRecentType.place:
        return SearchRecent(
          id: id,
          type: r.type,
          recordedAt: at,
          place: Place(id: r.placeId ?? '', name: 'Place'),
        );
    }
  }

  String _recentKey(RecordSearchRecent r) =>
      '${r.type.name}:${r.term ?? r.targetUserId ?? r.tag ?? r.placeId}';

  String _recentKeyOf(SearchRecent r) => switch (r.type) {
    SearchRecentType.term => 'term:${r.term}',
    SearchRecentType.account => 'account:${r.account?.id}',
    SearchRecentType.hashtag => 'hashtag:${r.hashtag?.tag}',
    SearchRecentType.place => 'place:${r.place?.id}',
  };

  // ── Helpers ───────────────────────────────────────────────────────────────────

  bool _takeFailQuery() {
    if (!failNextQuery) return false;
    failNextQuery = false;
    return true;
  }

  bool _takeFailMutation() {
    if (!failNextMutation) return false;
    failNextMutation = false;
    return true;
  }

  static String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  /// Lowercase + fold common diacritics (accent-insensitive match, per B#009).
  static String _norm(String s) {
    var out = s.toLowerCase().trim();
    const folds = {
      'áàảãạâấầẩẫậăắằẳẵặ': 'a',
      'éèẻẽẹêếềểễệ': 'e',
      'íìỉĩị': 'i',
      'óòỏõọôốồổỗộơớờởỡợ': 'o',
      'úùủũụưứừửữự': 'u',
      'ýỳỷỹỵ': 'y',
      'đ': 'd',
    };
    for (final entry in folds.entries) {
      for (final c in entry.key.split('')) {
        out = out.replaceAll(c, entry.value);
      }
    }
    return out;
  }
}
