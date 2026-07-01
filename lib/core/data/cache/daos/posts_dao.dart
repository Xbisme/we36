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
    return PostsCompanion.insert(
      id: p.id,
      authorId: p.author.id,
      authorUsername: Value(p.author.username),
      authorDisplayName: Value(p.author.displayName),
      authorAvatarUrl: Value(p.author.avatarUrl),
      authorIsVerified: p.author.isVerified,
      caption: Value(p.caption),
      mediaImageUrl: Value(p.primaryImageUrl),
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
    media: row.mediaImageUrl == null
        ? const []
        : [
            domain.PostMedia(
              position: 0,
              media: domain.Media(
                id: '${row.id}:0',
                kind: domain.MediaKind.image,
                status: domain.MediaStatus.ready,
                width: row.mediaWidth,
                height: row.mediaHeight,
                variants: {'display': row.mediaImageUrl},
              ),
            ),
          ],
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
}
