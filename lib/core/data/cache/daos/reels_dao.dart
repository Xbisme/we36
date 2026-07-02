import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/reels_table.dart';
import 'package:we36/core/data/feed/post.dart' as domain;
import 'package:we36/core/data/reels/reel.dart' as domain;

part 'reels_dao.g.dart';

/// DAO for the canonical cached reels feed (#008). Maps drift rows ↔
/// [domain.Reel], exposes the reactive reverse-chronological [watchReelsFeed]
/// every screen reads, applies server engagement reconciliation + comment-count
/// deltas, and clears the feed on refresh / logout (Constitution IX/I).
@DriftAccessor(tables: [Reels])
class ReelsDao extends DatabaseAccessor<AppDatabase> with _$ReelsDaoMixin {
  ReelsDao(super.attachedDatabase);

  /// Upsert a page of reels (dedupe by id — Constitution IX).
  Future<void> upsertAll(List<domain.Reel> reels) => batch((b) {
    b.insertAllOnConflictUpdate(
      this.reels,
      reels.map(_toCompanion).toList(),
    );
  });

  /// Reactive reverse-chronological reels feed — the single render source.
  Stream<List<domain.Reel>> watchReelsFeed({int limit = 100}) {
    final query = select(reels)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// Reactive read of one canonical reel by id. Emits null while not cached.
  Stream<domain.Reel?> watchReel(String id) =>
      (select(reels)..where((t) => t.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _toDomain(row));

  Future<domain.Reel?> getById(String id) async {
    final row = await (select(
      reels,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Upsert a single reel (optimistic write/rollback + optimistic create-insert).
  Future<void> upsert(domain.Reel reel) =>
      into(reels).insertOnConflictUpdate(_toCompanion(reel));

  /// Reconcile one reel with server-authoritative engagement counts.
  Future<void> applyEngagement(domain.EngagementState e) =>
      (update(reels)..where((t) => t.id.equals(e.postId))).write(
        ReelsCompanion(
          likeCount: Value(e.likeCount),
          saveCount: Value(e.saveCount),
          viewerHasLiked: Value(e.viewerHasLiked),
          viewerHasSaved: Value(e.viewerHasSaved),
        ),
      );

  /// Adjust a cached reel's `commentCount` by [delta], clamped at 0. No-op if the
  /// reel is not cached (owned by the comment add/delete use cases; Constitution
  /// IX).
  Future<void> adjustCommentCount(String id, int delta) async {
    final row = await (select(
      reels,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    final next = (row.commentCount + delta).clamp(0, 1 << 30);
    await (update(reels)..where((t) => t.id.equals(id))).write(
      ReelsCompanion(commentCount: Value(next)),
    );
  }

  /// Remove a single reel (own delete).
  Future<void> removeById(String id) =>
      (delete(reels)..where((t) => t.id.equals(id))).go();

  /// Clear the feed before repopulating from page 1 on refresh — reels the server
  /// no longer returns drop from cache.
  Future<void> clearFeed() => delete(reels).go();

  ReelsCompanion _toCompanion(domain.Reel r) => ReelsCompanion.insert(
    id: r.id,
    authorId: r.author.id,
    authorUsername: Value(r.author.username),
    authorDisplayName: Value(r.author.displayName),
    authorAvatarUrl: Value(r.author.avatarUrl),
    authorIsVerified: r.author.isVerified,
    caption: Value(r.caption),
    videoUrl: Value(r.videoUrl),
    posterUrl: Value(r.posterUrl),
    videoWidth: Value(r.video.width),
    videoHeight: Value(r.video.height),
    videoDurationMs: Value(r.video.durationMs),
    isVideoReady: r.isVideoReady,
    locationName: Value(r.location?.name),
    likeCount: r.likeCount,
    saveCount: r.saveCount,
    commentCount: r.commentCount,
    viewerHasLiked: r.viewerHasLiked,
    viewerHasSaved: r.viewerHasSaved,
    commentsDisabled: r.commentsDisabled,
    createdAt: r.createdAt,
    cachedAt: DateTime.now().toUtc(),
  );

  /// Reconstruct the domain [domain.Reel] from the flattened cache row, rebuilding
  /// the single video [domain.Media] with its poster/rendition variants so the
  /// domain `posterUrl`/`videoUrl` getters resolve.
  domain.Reel _toDomain(CachedReel row) => domain.Reel(
    id: row.id,
    author: domain.UserSummary(
      id: row.authorId,
      username: row.authorUsername,
      displayName: row.authorDisplayName,
      avatarUrl: row.authorAvatarUrl,
      isVerified: row.authorIsVerified,
    ),
    video: domain.Media(
      id: '${row.id}:video',
      kind: domain.MediaKind.video,
      status: row.isVideoReady
          ? domain.MediaStatus.ready
          : domain.MediaStatus.processing,
      width: row.videoWidth,
      height: row.videoHeight,
      durationMs: row.videoDurationMs,
      variants: {
        if (row.videoUrl != null)
          'renditions': [
            {'url': row.videoUrl},
          ],
        if (row.posterUrl != null) 'poster': {'url': row.posterUrl},
      },
    ),
    hashtags: const [],
    taggedUsers: const [],
    commentsDisabled: row.commentsDisabled,
    likeCount: row.likeCount,
    saveCount: row.saveCount,
    commentCount: row.commentCount,
    viewerHasLiked: row.viewerHasLiked,
    viewerHasSaved: row.viewerHasSaved,
    isVideoReady: row.isVideoReady,
    createdAt: row.createdAt,
    caption: row.caption,
    location: row.locationName == null
        ? null
        : domain.Place(id: '${row.id}:place', name: row.locationName!),
  );
}
