import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart'
    show ToggleLike, ToggleSave;
import 'package:we36/features/post/domain/usecases/comment_usecases.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';

/// Drives the post detail + comments (Constitution III/IX). The canonical post
/// is sourced from `watchPost` (so `commentCount` stays consistent with the feed
/// — SC-005); the comment list is cursor-paginated (oldest-first) with one-level
/// replies interleaved for display. Add/reply/like/delete are optimistic with
/// rollback; the confirmed count delta is owned by the `AddComment`/`DeleteComment`
/// use cases. A displayed `commentCount` overlay (`_pendingDelta`) reflects
/// in-flight optimistic mutations without double-counting the canonical write.
@injectable
class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit(
    this._watchPost,
    this._loadComments,
    this._loadReplies,
    this._addComment,
    this._toggleCommentLike,
    this._deleteComment,
    this._reportComment,
    this._keys,
    this._toggleLike,
    this._toggleSave,
  ) : super(const CommentsState.initial());

  final WatchPost _watchPost;
  final LoadComments _loadComments;
  final LoadReplies _loadReplies;
  final AddComment _addComment;
  final ToggleCommentLike _toggleCommentLike;
  final DeleteComment _deleteComment;
  final ReportComment _reportComment;
  final IdempotencyKeys _keys;
  final ToggleLike _toggleLike;
  final ToggleSave _toggleSave;

  late String _postId;
  Post? _post;
  StreamSubscription<Post?>? _postSub;

  final List<Comment> _topLevel = [];
  final Map<String, List<Comment>> _repliesByParent = {};
  String? _cursor;
  bool _hasMore = false;
  bool _busy = false;
  int _pendingDelta = 0;
  ReplyContext? _replyContext;

  CommentAuthor get _me => const CommentAuthor(
    id: 'user-me',
    username: 'you',
    isVerified: false,
  );

  /// Cold start: subscribe to the canonical post and load the first page.
  Future<void> load(String postId) async {
    if (_postSub != null) return;
    _postId = postId;
    emit(const CommentsState.loading());
    _post = await _watchPost(postId).first;
    _postSub = _watchPost(postId).listen(_onPost);
    await _fetchFirst();
  }

  void _onPost(Post? post) {
    _post = post;
    if (state is CommentsLoaded || state is CommentsLoadedPaginating) {
      _emitLoaded();
    }
  }

  Future<void> _fetchFirst() async {
    final result = await _loadComments(_postId);
    if (isClosed) return;
    if (result.isOk) {
      final page = result.valueOrNull!;
      _topLevel
        ..clear()
        ..addAll(page.items);
      _sortTop();
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      await _loadRepliesFor(page.items);
      if (isClosed) return;
      _emitLoaded();
    } else {
      emit(CommentsState.error(result.failureOrNull!));
    }
  }

  /// Re-attempt the first page from the error state.
  Future<void> retry() async {
    emit(const CommentsState.loading());
    await _fetchFirst();
  }

  /// Append the next page (soft-fail keeps items).
  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    if (state is! CommentsLoaded) return;
    _busy = true;
    _emitLoaded(paginating: true);
    final result = await _loadComments(_postId, cursor: _cursor);
    if (!isClosed && result.isOk) {
      final page = result.valueOrNull!;
      _topLevel.addAll(page.items);
      _sortTop();
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      await _loadRepliesFor(page.items);
    }
    if (!isClosed) _emitLoaded();
    _busy = false;
  }

  /// Load (or refresh) a top-level comment's replies on demand (US3).
  Future<void> loadReplies(String parentId) async {
    final result = await _loadReplies(parentId);
    if (isClosed || !result.isOk) return;
    _repliesByParent[parentId] = [...result.valueOrNull!.items]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _emitLoaded();
  }

  Future<void> _loadRepliesFor(List<Comment> tops) async {
    for (final c in tops.where((c) => c.replyCount > 0)) {
      final result = await _loadReplies(c.id);
      if (isClosed) return;
      if (result.isOk) {
        _repliesByParent[c.id] = [...result.valueOrNull!.items]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
    }
  }

  // ---- Reply composition (US3) ----------------------------------------------

  void startReply(Comment target) {
    final parentId = target.parentId ?? target.id;
    final handle =
        '@${target.author.username ?? target.author.displayName ?? ''}';
    _replyContext = ReplyContext(parentId: parentId, handle: handle);
    _emitLoaded();
  }

  void cancelReply() {
    _replyContext = null;
    _emitLoaded();
  }

  // ---- Add / reply (US2/US3) ------------------------------------------------

  /// Optimistically add a comment (or reply if [ReplyContext] is active).
  /// Returns a failure to toast, or null on success.
  Future<AppFailure?> addComment(String text) async {
    final trimmed = text.trim();
    // Defensive no-op — the input enforces non-empty + ≤maxLength (FR-013).
    if (trimmed.isEmpty || trimmed.length > Comment.maxLength) return null;
    final key = _keys.generate();
    final parentId = _replyContext?.parentId;
    final optimistic = Comment(
      id: 'pending-$key',
      postId: _postId,
      author: _me,
      text: trimmed,
      createdAt: DateTime.now().toUtc(),
      likeCount: 0,
      viewerHasLiked: false,
      isOwn: true,
      parentId: parentId,
      pending: true,
      clientKey: key,
    );
    _insert(optimistic);
    _pendingDelta += 1;
    _replyContext = null;
    _emitLoaded();

    final result = await _addComment(
      _postId,
      text: trimmed,
      clientKey: key,
      parentId: parentId,
    );
    if (isClosed) return null;
    _pendingDelta -= 1;
    if (result.isOk) {
      _replaceByKey(key, result.valueOrNull!);
      _emitLoaded();
      return null;
    }
    _removeByKey(key);
    _emitLoaded();
    return result.failureOrNull;
  }

  // ---- Like (US4) -----------------------------------------------------------

  Future<AppFailure?> toggleLike(Comment comment) async {
    final target = !comment.viewerHasLiked;
    _updateComment(
      comment.id,
      (c) => c.copyWith(
        viewerHasLiked: target,
        likeCount: c.likeCount + (target ? 1 : -1),
      ),
    );
    _emitLoaded();
    final result = await _toggleCommentLike(comment.id, like: target);
    if (isClosed) return null;
    if (result.isOk) {
      final e = result.valueOrNull!;
      // Reconcile to the server target-state (last-intent wins).
      _updateComment(
        comment.id,
        (c) => c.copyWith(
          viewerHasLiked: e.viewerHasLiked,
          likeCount: e.likeCount,
        ),
      );
      _emitLoaded();
      return null;
    }
    // Revert.
    _updateComment(
      comment.id,
      (c) => c.copyWith(
        viewerHasLiked: comment.viewerHasLiked,
        likeCount: comment.likeCount,
      ),
    );
    _emitLoaded();
    return result.failureOrNull;
  }

  // ---- Delete / report (US5) ------------------------------------------------

  Future<AppFailure?> deleteComment(Comment comment) async {
    final isTop = comment.parentId == null;
    // Snapshot for rollback.
    final topSnapshot = [..._topLevel];
    final repliesSnapshot = {
      for (final e in _repliesByParent.entries) e.key: [...e.value],
    };
    final removed = isTop ? 1 + comment.replyCount : 1;
    _remove(comment);
    _pendingDelta -= removed;
    _emitLoaded();

    final result = await _deleteComment(comment.id, postId: _postId);
    if (isClosed) return null;
    _pendingDelta += removed;
    if (result.isOk) {
      _emitLoaded();
      return null;
    }
    // Rollback.
    _topLevel
      ..clear()
      ..addAll(topSnapshot);
    _repliesByParent
      ..clear()
      ..addAll(repliesSnapshot);
    _emitLoaded();
    return result.failureOrNull;
  }

  Future<AppFailure?> reportComment(Comment comment) async {
    final result = await _reportComment(comment.id);
    return result.isOk ? null : result.failureOrNull;
  }

  // ---- Post like / save (optimistic; reflected via watchPost) ---------------

  /// Toggle like on the post being viewed (optimistic + idempotent in the feed
  /// repository; the canonical post flips via the `watchPost` stream).
  Future<AppFailure?> togglePostLike() async {
    final post = _post;
    if (post == null) return null;
    final result = await _toggleLike(post.id, like: !post.viewerHasLiked);
    return result.isOk ? null : result.failureOrNull;
  }

  /// Toggle save on the post being viewed.
  Future<AppFailure?> togglePostSave() async {
    final post = _post;
    if (post == null) return null;
    final result = await _toggleSave(post.id, save: !post.viewerHasSaved);
    return result.isOk ? null : result.failureOrNull;
  }

  // ---- Internals ------------------------------------------------------------

  void _sortTop() =>
      _topLevel.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  void _insert(Comment c) {
    if (c.parentId == null) {
      _topLevel.add(c);
    } else {
      (_repliesByParent[c.parentId!] ??= []).add(c);
      final i = _topLevel.indexWhere((t) => t.id == c.parentId);
      if (i >= 0) {
        _topLevel[i] = _topLevel[i].copyWith(
          replyCount: _topLevel[i].replyCount + 1,
        );
      }
    }
  }

  void _replaceByKey(String key, Comment confirmed) {
    final ti = _topLevel.indexWhere((c) => c.clientKey == key);
    if (ti >= 0) {
      _topLevel[ti] = confirmed;
      return;
    }
    for (final list in _repliesByParent.values) {
      final ri = list.indexWhere((c) => c.clientKey == key);
      if (ri >= 0) {
        list[ri] = confirmed;
        return;
      }
    }
  }

  void _removeByKey(String key) {
    final ti = _topLevel.indexWhere((c) => c.clientKey == key);
    if (ti >= 0) {
      _topLevel.removeAt(ti);
      return;
    }
    for (final entry in _repliesByParent.entries) {
      final ri = entry.value.indexWhere((c) => c.clientKey == key);
      if (ri >= 0) {
        entry.value.removeAt(ri);
        final pi = _topLevel.indexWhere((t) => t.id == entry.key);
        if (pi >= 0) {
          _topLevel[pi] = _topLevel[pi].copyWith(
            replyCount: (_topLevel[pi].replyCount - 1).clamp(0, 1 << 30),
          );
        }
        return;
      }
    }
  }

  void _updateComment(String id, Comment Function(Comment) fn) {
    final ti = _topLevel.indexWhere((c) => c.id == id);
    if (ti >= 0) {
      _topLevel[ti] = fn(_topLevel[ti]);
      return;
    }
    for (final list in _repliesByParent.values) {
      final ri = list.indexWhere((c) => c.id == id);
      if (ri >= 0) {
        list[ri] = fn(list[ri]);
        return;
      }
    }
  }

  void _remove(Comment comment) {
    if (comment.parentId == null) {
      _topLevel.removeWhere((c) => c.id == comment.id);
      _repliesByParent.remove(comment.id);
    } else {
      _repliesByParent[comment.parentId]?.removeWhere(
        (c) => c.id == comment.id,
      );
      final pi = _topLevel.indexWhere((t) => t.id == comment.parentId);
      if (pi >= 0) {
        _topLevel[pi] = _topLevel[pi].copyWith(
          replyCount: (_topLevel[pi].replyCount - 1).clamp(0, 1 << 30),
        );
      }
    }
  }

  List<Comment> _buildDisplay() {
    final out = <Comment>[];
    for (final top in _topLevel) {
      out.add(top);
      final replies = _repliesByParent[top.id];
      if (replies != null) out.addAll(replies);
    }
    return out;
  }

  void _emitLoaded({bool paginating = false}) {
    final post = _post == null
        ? null
        : _post!.copyWith(
            commentCount: (_post!.commentCount + _pendingDelta).clamp(
              0,
              1 << 30,
            ),
          );
    final comments = _buildDisplay();
    emit(
      paginating
          ? CommentsState.loadedPaginating(
              post: post,
              comments: comments,
              hasMore: _hasMore,
              nextCursor: _cursor,
              replyContext: _replyContext,
            )
          : CommentsState.loaded(
              post: post,
              comments: comments,
              hasMore: _hasMore,
              nextCursor: _cursor,
              replyContext: _replyContext,
            ),
    );
  }

  @override
  Future<void> close() async {
    await _postSub?.cancel();
    return super.close();
  }
}
