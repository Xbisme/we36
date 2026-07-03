import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/posts_table.dart';
import 'package:we36/core/data/feed/post.dart' as domain;

part 'posts_dao.g.dart';

/// DAO for the canonical cached feed (#004). Maps drift rows ↔ [domain.Post],
/// exposes the reactive reverse-chronological [watchHomeFeed] every screen reads,
/// applies server engagement reconciliation, and clears the feed on
/// refresh / logout (Constitution IX/I).
@DriftAccessor(tables: [Posts])
class PostsDao extends DatabaseAccessor<AppDatabase> with _$PostsDaoMixin {
  PostsDao(super.attachedDatabase);

  /// Upsert a page of posts (dedupe by id — Constitution IX).
  Future<void> upsertAll(List<domain.Post> posts) => batch((b) {
    b.insertAllOnConflictUpdate(
      this.posts,
      posts.map(_toCompanion).toList(),
    );
  });

  /// Reactive reverse-chronological feed — the single render source (FR-004).
  Stream<List<domain.Post>> watchHomeFeed({int limit = 100}) {
    final query = select(posts)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<domain.Post?> getById(String id) async {
    final row = await (select(
      posts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Reactive read of one canonical post by id — the post-detail render source
  /// (#006). Emits null while the post is not cached.
  Stream<domain.Post?> watchPost(String id) =>
      (select(posts)..where((t) => t.id.equals(id))).watchSingleOrNull().map(
        (row) => row == null ? null : _toDomain(row),
      );

  /// Adjust a cached post's `commentCount` by [delta], clamped at 0 (#006).
  /// No-op if the post is not cached.
  Future<void> adjustCommentCount(String id, int delta) async {
    final row = await (select(
      posts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    final next = (row.commentCount + delta).clamp(0, 1 << 30);
    await (update(posts)..where((t) => t.id.equals(id))).write(
      PostsCompanion(commentCount: Value(next)),
    );
  }

  /// Reconcile one post with server-authoritative engagement counts (FR-013).
  Future<void> applyEngagement(domain.EngagementState e) =>
      (update(posts)..where((t) => t.id.equals(e.postId))).write(
        PostsCompanion(
          likeCount: Value(e.likeCount),
          saveCount: Value(e.saveCount),
          viewerHasLiked: Value(e.viewerHasLiked),
          viewerHasSaved: Value(e.viewerHasSaved),
        ),
      );

  /// Upsert a single post (used by optimistic write + rollback).
  Future<void> upsert(domain.Post post) =>
      into(posts).insertOnConflictUpdate(_toCompanion(post));

  /// Clear the feed before repopulating from page 1 on refresh — posts the
  /// server no longer returns (removed/withheld) drop from cache (FR-035).
  Future<void> clearFeed() => delete(posts).go();

  PostsCompanion _toCompanion(domain.Post p) {
    final firstMedia = p.media.isEmpty
        ? null
        : ([
            ...p.media,
          ]..sort((a, b) => a.position.compareTo(b.position))).first.media;
    final urls = p.imageUrls;
    return PostsCompanion.insert(
      id: p.id,
      authorId: p.author.id,
      authorUsername: Value(p.author.username),
      authorDisplayName: Value(p.author.displayName),
      authorAvatarUrl: Value(p.author.avatarUrl),
      authorIsVerified: p.author.isVerified,
      caption: Value(p.caption),
      mediaImageUrl: Value(p.primaryImageUrl),
      mediaUrlsJson: Value(urls.length > 1 ? jsonEncode(urls) : null),
      mediaWidth: Value(firstMedia?.width),
      mediaHeight: Value(firstMedia?.height),
      locationName: Value(p.location?.name),
      likeCount: p.likeCount,
      saveCount: p.saveCount,
      commentCount: p.commentCount,
      viewerHasLiked: p.viewerHasLiked,
      viewerHasSaved: p.viewerHasSaved,
      commentsDisabled: p.commentsDisabled,
      createdAt: p.createdAt,
      cachedAt: DateTime.now().toUtc(),
    );
  }

  /// Reconstruct the domain [domain.Post] from the flattened cache row. The
  /// single cached image is re-wrapped as a ready image `media[0]`; the full
  /// carousel/original media is re-fetched from the server (not cached in #004).
  domain.Post _toDomain(CachedPost row) => domain.Post(
    id: row.id,
    author: domain.UserSummary(
      id: row.authorId,
      username: row.authorUsername,
      displayName: row.authorDisplayName,
      avatarUrl: row.authorAvatarUrl,
      isVerified: row.authorIsVerified,
    ),
    media: _mediaFromRow(row),
    hashtags: const [],
    taggedUsers: const [],
    commentsDisabled: row.commentsDisabled,
    likeCount: row.likeCount,
    saveCount: row.saveCount,
    commentCount: row.commentCount,
    viewerHasLiked: row.viewerHasLiked,
    viewerHasSaved: row.viewerHasSaved,
    createdAt: row.createdAt,
    caption: row.caption,
    location: row.locationName == null
        ? null
        : domain.Place(id: '${row.id}:place', name: row.locationName!),
  );

  /// Rebuild the carousel media from the cached row: the full URL list
  /// (`mediaUrlsJson`) when a multi-photo post was cached, else the single
  /// `mediaImageUrl`, else empty. Each URL is wrapped as a ready image so the
  /// domain `imageUrls`/`primaryImageUrl` getters resolve it.
  List<domain.PostMedia> _mediaFromRow(CachedPost row) {
    final urls = <String>[];
    final raw = row.mediaUrlsJson;
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        urls.addAll(decoded.whereType<String>());
      }
    }
    if (urls.isEmpty && row.mediaImageUrl != null) {
      urls.add(row.mediaImageUrl!);
    }
    return [
      for (var i = 0; i < urls.length; i++)
        domain.PostMedia(
          position: i,
          media: domain.Media(
            id: '${row.id}:$i',
            kind: domain.MediaKind.image,
            status: domain.MediaStatus.ready,
            width: i == 0 ? row.mediaWidth : null,
            height: i == 0 ? row.mediaHeight : null,
            variants: {'display': urls[i]},
          ),
        ),
    ];
  }
}
