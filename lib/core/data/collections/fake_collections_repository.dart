import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/collections_repository.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory [CollectionsRepository] (`fake` env): a small self-contained saved
/// graph — a catalog of savable posts/reels, a canonical saved set ("All saved"),
/// and named collections — so the app builds/tests zero-network (Constitution
/// VIII). Covers are derived from live members (so removing/unsaving a cover item
/// falls back automatically — FR-010). Fail seams drive rollback tests. Uses no
/// wall-clock (deterministic seeded timestamps — the post-#10 time-bomb learning).
@LazySingleton(as: CollectionsRepository, env: ['fake'])
class FakeCollectionsRepository implements CollectionsRepository {
  FakeCollectionsRepository() {
    _seed();
  }

  /// Test seams: fail the next read / next mutation once.
  bool failNextQuery = false;
  bool failNextMutation = false;

  static const int _pageSize = 6;

  final StreamController<void> _changes = StreamController<void>.broadcast();
  final Map<String, ExploreItem> _catalog = {}; // postId -> savable item
  final Set<String> _savedIds = {}; // canonical saved set ("All saved")
  final Map<String, _Collection> _cols = {}; // named collections by id
  final Map<String, SavedCollection> _createdByKey = {}; // create idempotency
  int _seq = 0;

  DateTime _stamp() => DateTime.utc(2026).add(Duration(minutes: _seq));

  void _seed() {
    for (var i = 0; i < 10; i++) {
      final item = _item(i);
      _catalog[item.id] = item;
    }
    final ids = _catalog.keys.toList();
    // Save the first 6 items into "All saved".
    _savedIds.addAll(ids.take(6));
    // A populated collection with a set cover, and an empty one.
    _cols['col_food'] = _Collection(
      id: 'col_food',
      name: 'Food',
      order: _seq++,
      updatedAt: _stamp(),
      members: {ids[0], ids[1], ids[2]},
      coverItemId: ids[2],
    );
    _cols['col_trips'] = _Collection(
      id: 'col_trips',
      name: 'Trips',
      order: _seq++,
      updatedAt: _stamp(),
    );
  }

  // ---- reads -------------------------------------------------------------

  @override
  Stream<List<SavedCollection>> watchCollections() async* {
    yield _snapshot();
    yield* _changes.stream.map((_) => _snapshot());
  }

  @override
  Future<Result<void>> refreshCollections() async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    _emit();
    return const Result.ok(null);
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> collectionItems(
    String id, {
    String? cursor,
  }) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    final col = _cols[id];
    if (col == null) return const Result.err(AppFailure.notFound());
    final items = col.members
        .map((pid) => _catalog[pid])
        .whereType<ExploreItem>() // skip deleted/unavailable items (edge case)
        .toList();
    return Result.ok(_paginate(items, cursor));
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> allSaved({String? cursor}) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    final items = _savedIds
        .map((pid) => _catalog[pid])
        .whereType<ExploreItem>()
        .toList();
    return Result.ok(_paginate(items, cursor));
  }

  @override
  Future<Result<PostCollectionsMembership>> membership(String postId) async {
    if (_takeFailQuery()) return const Result.err(AppFailure.offline());
    return Result.ok(
      PostCollectionsMembership(
        postId: postId,
        isSaved: _savedIds.contains(postId),
        collections: _orderedCols()
            .map(
              (c) => CollectionPickerRow(
                collection: _toDomain(c),
                contains: c.members.contains(postId),
              ),
            )
            .toList(),
      ),
    );
  }

  // ---- mutations ---------------------------------------------------------

  @override
  Future<Result<SavedCollection>> create(
    String name, {
    String? idempotencyKey,
  }) async {
    if (idempotencyKey != null && _createdByKey.containsKey(idempotencyKey)) {
      return Result.ok(_createdByKey[idempotencyKey]!);
    }
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final id = 'col_${_seq++}';
    final col = _Collection(
      id: id,
      name: name.trim(),
      order: _seq,
      updatedAt: _stamp(),
    );
    _cols[id] = col;
    final domain = _toDomain(col);
    if (idempotencyKey != null) _createdByKey[idempotencyKey] = domain;
    _emit();
    return Result.ok(domain);
  }

  @override
  Future<Result<SavedCollection>> rename(String id, String name) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final col = _cols[id];
    if (col == null) return const Result.err(AppFailure.notFound());
    col
      ..name = name.trim()
      ..updatedAt = _stamp();
    _emit();
    return Result.ok(_toDomain(col));
  }

  @override
  Future<Result<SavedCollection>> setCover(
    String id,
    String coverItemId,
  ) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final col = _cols[id];
    if (col == null) return const Result.err(AppFailure.notFound());
    col
      ..coverItemId = coverItemId
      ..updatedAt = _stamp();
    _emit();
    return Result.ok(_toDomain(col));
  }

  @override
  Future<Result<void>> delete(String id) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    // Posts stay saved (SC-006) — only the collection grouping is removed.
    _cols.remove(id);
    _emit();
    return const Result.ok(null);
  }

  @override
  Future<Result<SavedCollection>> file(
    String collectionId,
    String postId, {
    String? idempotencyKey,
  }) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final col = _cols[collectionId];
    if (col == null) return const Result.err(AppFailure.notFound());
    col.members.add(postId); // idempotent (Set)
    _savedIds.add(postId); // filing an unsaved post also saves it
    col.updatedAt = _stamp();
    _emit();
    return Result.ok(_toDomain(col));
  }

  @override
  Future<Result<SavedCollection>> unfile(
    String collectionId,
    String postId,
  ) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    final col = _cols[collectionId];
    if (col == null) return const Result.err(AppFailure.notFound());
    col.members.remove(postId); // stays saved elsewhere + in "All saved"
    col.updatedAt = _stamp();
    _emit();
    return Result.ok(_toDomain(col));
  }

  @override
  Future<Result<void>> unsave(String postId) async {
    if (_takeFailMutation()) return const Result.err(AppFailure.networkError());
    _savedIds.remove(postId);
    for (final col in _cols.values) {
      col.members.remove(postId); // cascade — removed everywhere (SC-007)
    }
    _emit();
    return const Result.ok(null);
  }

  // ---- helpers -----------------------------------------------------------

  List<SavedCollection> _snapshot() => [
    _allSaved(),
    for (final c in _orderedCols()) _toDomain(c),
  ];

  List<_Collection> _orderedCols() =>
      _cols.values.toList()..sort((a, b) => a.order.compareTo(b.order));

  SavedCollection _allSaved() => SavedCollection(
    id: kAllSavedCollectionId,
    name: 'All saved',
    itemCount: _savedIds.length,
    coverRefs: _covers(_savedIds.toList()),
    isDefault: true,
    updatedAt: _stamp(),
  );

  SavedCollection _toDomain(_Collection c) {
    // Cover = the set cover first (if still a member), then remaining members —
    // so removing/unsaving the cover item falls back automatically (FR-010).
    final ordered = <String>[
      if (c.coverItemId != null && c.members.contains(c.coverItemId))
        c.coverItemId!,
      ...c.members.where((m) => m != c.coverItemId),
    ];
    return SavedCollection(
      id: c.id,
      name: c.name,
      itemCount: c.members.length,
      coverRefs: _covers(ordered),
      updatedAt: c.updatedAt,
    );
  }

  List<String> _covers(List<String> postIds) => postIds
      .map((pid) => _catalog[pid]?.thumbnailUrl)
      .whereType<String>()
      .take(4)
      .toList();

  CursorPage<T> _paginate<T>(List<T> all, String? cursor) {
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final slice = all.skip(offset).take(_pageSize).toList();
    final next = offset + _pageSize;
    final hasMore = next < all.length;
    return CursorPage<T>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  ExploreItem _item(int i) {
    const author = UserSummary(
      id: 'u_demo',
      isVerified: false,
      username: 'demo',
      displayName: 'You',
    );
    final createdAt = DateTime.utc(2026).add(Duration(hours: i));
    final variants = <String, dynamic>{
      'renditions': [
        {'label': 'feed', 'url': 'https://cdn.we36.test/$i.webp'},
      ],
    };
    if (i.isOdd) {
      return ExploreItem(
        kind: ExploreItemKind.reel,
        reel: Reel(
          id: 'saved-reel-$i',
          author: author,
          video: Media(
            id: 'm$i',
            kind: MediaKind.video,
            status: MediaStatus.ready,
            width: 720,
            height: 1280,
            variants: variants,
          ),
          hashtags: const [],
          taggedUsers: const [],
          commentsDisabled: false,
          likeCount: 10 + i,
          saveCount: 1,
          commentCount: 0,
          viewerHasLiked: false,
          viewerHasSaved: true,
          isVideoReady: true,
          createdAt: createdAt,
        ),
      );
    }
    return ExploreItem(
      kind: ExploreItemKind.post,
      post: Post(
        id: 'saved-post-$i',
        author: author,
        media: [
          PostMedia(
            position: 0,
            media: Media(
              id: 'm$i',
              kind: MediaKind.image,
              status: MediaStatus.ready,
              width: 1080,
              height: 1350,
              variants: variants,
            ),
          ),
        ],
        hashtags: const [],
        taggedUsers: const [],
        commentsDisabled: false,
        likeCount: 20 + i,
        saveCount: 1,
        commentCount: 0,
        viewerHasLiked: false,
        viewerHasSaved: true,
        createdAt: createdAt,
      ),
    );
  }

  void _emit() {
    if (!_changes.isClosed) _changes.add(null);
  }

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

  void dispose() => _changes.close();
}

/// Mutable in-memory named collection (fake only).
class _Collection {
  _Collection({
    required this.id,
    required this.name,
    required this.order,
    required this.updatedAt,
    Set<String>? members,
    this.coverItemId,
  }) : members = members ?? <String>{};

  final String id;
  String name;
  final int order;
  DateTime updatedAt;
  final Set<String> members;
  String? coverItemId;
}
