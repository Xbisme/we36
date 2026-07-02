import 'package:injectable/injectable.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comment_engagement.dart';
import 'package:we36/core/data/comments/comments_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Default #006 [CommentsRepository]: a deterministic in-memory conversation per
/// post (no network — Constitution XII). Comments are transient (not persisted);
/// only the canonical `Post` is cached (plan R2). The `AddComment`/`DeleteComment`
/// use cases own the `Post.commentCount` reconciliation — this repo never touches
/// the post cache (plan R3).
@LazySingleton(as: CommentsRepository, env: ['fake'])
class FakeCommentsRepository implements CommentsRepository {
  FakeCommentsRepository({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  /// Constructor injectable uses (it can't resolve the inline function type of
  /// the `clock` test seam above, so we expose a parameterless factory).
  @factoryMethod
  factory FakeCommentsRepository.create() => FakeCommentsRepository();

  final DateTime Function() _clock;

  /// The current viewer id (matches the fake session's own user).
  static const String meId = 'user-me';

  static const List<String> _authors = ['maya', 'leo', 'ava', 'noah', 'ivy'];
  static const int _pageSize = 20;
  static final DateTime _base = DateTime.utc(2026, 7, 1, 9);

  /// Flat comments (top-level + replies) per post id.
  final Map<String, List<Comment>> _byPost = {};

  /// Idempotency ledger: clientKey → created comment (retry ⇒ same comment).
  final Map<String, Comment> _byKey = {};

  int _seq = 0;

  /// Test seam: when true, the next add fails once (rollback / retry tests).
  bool failNextAdd = false;

  /// Test seam: when true, the next `loadComments` fails once (error/retry).
  bool failNextLoad = false;

  /// Test seam: when true, the next like/delete fails once (rollback tests).
  bool failNextMutation = false;

  // ---- Seeding ---------------------------------------------------------------

  List<Comment> _ensure(String postId) =>
      _byPost.putIfAbsent(postId, () => _seed(postId));

  List<Comment> _seed(String postId) {
    // Deterministic sizes: `…004` → empty, `…000` → high-volume (pagination),
    // otherwise a small thread with one replied-to comment.
    final int count;
    if (postId.endsWith('004')) {
      count = 0;
    } else if (postId.endsWith('000')) {
      count = 25;
    } else {
      count = 5;
    }
    final list = <Comment>[];
    for (var i = 0; i < count; i++) {
      final author = _authors[i % _authors.length];
      final isOwn = i % 4 == 0;
      final id = '$postId-c${i.toString().padLeft(2, '0')}';
      final hasReplies = i == 0 && count > 1;
      list.add(
        Comment(
          id: id,
          postId: postId,
          author: _author(isOwn ? 'me' : author, own: isOwn),
          text: i.isEven
              ? 'this is so good @$author 🔥'
              : 'love the light here #goldenhour',
          createdAt: _base.add(Duration(minutes: i * 3)),
          likeCount: (i * 2) % 7,
          viewerHasLiked: i % 3 == 0,
          isOwn: isOwn,
          replyCount: hasReplies ? 2 : 0,
        ),
      );
      if (hasReplies) {
        for (var r = 0; r < 2; r++) {
          list.add(
            Comment(
              id: '$id-r$r',
              postId: postId,
              author: _author(_authors[(r + 1) % _authors.length]),
              text: r == 0 ? 'agreed!' : 'stunning 😍',
              createdAt: _base.add(Duration(minutes: i * 3 + r + 1)),
              likeCount: r,
              viewerHasLiked: false,
              isOwn: false,
              parentId: id,
            ),
          );
        }
      }
    }
    return list;
  }

  CommentAuthor _author(String handle, {bool own = false}) => CommentAuthor(
    id: own ? meId : 'user-$handle',
    username: own ? 'you' : handle,
    displayName: '${handle[0].toUpperCase()}${handle.substring(1)}',
    isVerified: handle.hashCode.isEven,
  );

  CursorPage<Comment> _page(List<Comment> sorted, String? cursor, int limit) {
    final offset = int.tryParse(cursor ?? '0') ?? 0;
    final slice = sorted.skip(offset).take(limit).toList();
    final next = offset + limit;
    final hasMore = next < sorted.length;
    return CursorPage<Comment>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  // ---- Reads -----------------------------------------------------------------

  @override
  Future<Result<CursorPage<Comment>>> loadComments(
    String postId, {
    String? cursor,
    int limit = _pageSize,
  }) async {
    if (failNextLoad) {
      failNextLoad = false;
      return const Result<CursorPage<Comment>>.err(AppFailure.networkError());
    }
    final top = _ensure(postId).where((c) => c.parentId == null).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Result<CursorPage<Comment>>.ok(_page(top, cursor, limit));
  }

  @override
  Future<Result<CursorPage<Comment>>> loadReplies(
    String parentId, {
    String? cursor,
    int limit = _pageSize,
  }) async {
    // A parent belongs to exactly one post; find it across seeded posts.
    final replies = <Comment>[];
    for (final list in _byPost.values) {
      replies.addAll(list.where((c) => c.parentId == parentId));
    }
    replies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Result<CursorPage<Comment>>.ok(_page(replies, cursor, limit));
  }

  // ---- Mutations -------------------------------------------------------------

  @override
  Future<Result<Comment>> addComment(
    String postId, {
    required String text,
    required String clientKey,
    String? parentId,
  }) async {
    // Idempotent: a retry with the same key returns the same comment.
    final existing = _byKey[clientKey];
    if (existing != null) return Result<Comment>.ok(existing);
    if (failNextAdd) {
      failNextAdd = false;
      return const Result<Comment>.err(AppFailure.networkError());
    }
    final list = _ensure(postId);
    final normalizedParent = _normalizeParent(list, parentId);
    final created = Comment(
      id: 'srv-${_seq++}-$clientKey',
      postId: postId,
      author: _author('me', own: true),
      text: text,
      createdAt: _clock(),
      likeCount: 0,
      viewerHasLiked: false,
      isOwn: true,
      parentId: normalizedParent,
    );
    list.add(created);
    if (normalizedParent != null) {
      final pIdx = list.indexWhere((c) => c.id == normalizedParent);
      if (pIdx >= 0) {
        list[pIdx] = list[pIdx].copyWith(
          replyCount: list[pIdx].replyCount + 1,
        );
      }
    }
    _byKey[clientKey] = created;
    return Result<Comment>.ok(created);
  }

  /// A reply to any comment/reply attaches to the top-level ancestor (one level).
  String? _normalizeParent(List<Comment> list, String? parentId) {
    if (parentId == null) return null;
    final target = list.where((c) => c.id == parentId).firstOrNull;
    if (target == null) return parentId;
    return target.parentId ?? target.id;
  }

  @override
  Future<Result<CommentEngagement>> toggleCommentLike(
    String commentId, {
    required bool like,
  }) async {
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<CommentEngagement>.err(AppFailure.networkError());
    }
    for (final list in _byPost.values) {
      final idx = list.indexWhere((c) => c.id == commentId);
      if (idx < 0) continue;
      final prior = list[idx];
      final delta = (like ? 1 : 0) - (prior.viewerHasLiked ? 1 : 0);
      final next = prior.copyWith(
        viewerHasLiked: like,
        likeCount: prior.likeCount + delta,
      );
      list[idx] = next;
      return Result<CommentEngagement>.ok(
        CommentEngagement(
          likeCount: next.likeCount,
          viewerHasLiked: next.viewerHasLiked,
        ),
      );
    }
    return const Result<CommentEngagement>.err(AppFailure.notFound());
  }

  @override
  Future<Result<int>> deleteComment(String commentId) async {
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<int>.err(AppFailure.networkError());
    }
    for (final list in _byPost.values) {
      final idx = list.indexWhere((c) => c.id == commentId);
      if (idx < 0) continue;
      final target = list[idx];
      if (target.parentId == null) {
        // Top-level: cascade its replies.
        final replies = list.where((c) => c.parentId == commentId).length;
        list.removeWhere((c) => c.id == commentId || c.parentId == commentId);
        return Result<int>.ok(1 + replies);
      }
      // Reply: decrement its parent's replyCount.
      list.removeAt(idx);
      final pIdx = list.indexWhere((c) => c.id == target.parentId);
      if (pIdx >= 0) {
        list[pIdx] = list[pIdx].copyWith(
          replyCount: (list[pIdx].replyCount - 1).clamp(0, 1 << 30),
        );
      }
      return const Result<int>.ok(1);
    }
    return const Result<int>.ok(0); // already gone — no-op
  }

  @override
  Future<Result<void>> reportComment(String commentId) async =>
      const Result<void>.ok(null);
}
