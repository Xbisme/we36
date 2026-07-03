import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/post/domain/usecases/comment_usecases.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';
import 'package:we36/features/reels/domain/usecases/reel_comment_usecases.dart';

/// Drives the reel comments bottom sheet (#008). Reuses the shared, target-agnostic
/// `CommentsRepository` seams (`LoadComments`/`LoadReplies`/`ToggleCommentLike`/
/// `ReportComment` from #006) plus reel-scoped `AddReelComment`/`DeleteReelComment`
/// that route the canonical count delta to `ReelsRepository` (plan R7). Reuses the
/// #006 `CommentsState` with `post: null` — the reel's `commentCount` is shown by
/// the sheet from the canonical reel, not this state. Zero changes to #006.
@injectable
class ReelCommentsCubit extends Cubit<CommentsState> {
  ReelCommentsCubit(
    this._loadComments,
    this._loadReplies,
    this._addComment,
    this._toggleCommentLike,
    this._deleteComment,
    this._reportComment,
    this._keys,
  ) : super(const CommentsState.initial());

  final LoadComments _loadComments;
  final LoadReplies _loadReplies;
  final AddReelComment _addComment;
  final ToggleCommentLike _toggleCommentLike;
  final DeleteReelComment _deleteComment;
  final ReportComment _reportComment;
  final IdempotencyKeys _keys;

  late String _reelId;
  final List<Comment> _topLevel = [];
  final Map<String, List<Comment>> _repliesByParent = {};
  String? _cursor;
  bool _hasMore = false;
  bool _busy = false;
  ReplyContext? _replyContext;

  CommentAuthor get _me =>
      const CommentAuthor(id: 'user-me', username: 'you', isVerified: false);

  Future<void> load(String reelId) async {
    _reelId = reelId;
    emit(const CommentsState.loading());
    await _fetchFirst();
  }

  Future<void> _fetchFirst() async {
    final result = await _loadComments(_reelId);
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

  Future<void> retry() async {
    emit(const CommentsState.loading());
    await _fetchFirst();
  }

  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null) return;
    if (state is! CommentsLoaded) return;
    _busy = true;
    _emitLoaded(paginating: true);
    final result = await _loadComments(_reelId, cursor: _cursor);
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

  Future<AppFailure?> addComment(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || trimmed.length > Comment.maxLength) return null;
    final key = _keys.generate();
    final parentId = _replyContext?.parentId;
    final optimistic = Comment(
      id: 'pending-$key',
      postId: _reelId,
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
    _replyContext = null;
    _emitLoaded();

    final result = await _addComment(
      _reelId,
      text: trimmed,
      clientKey: key,
      parentId: parentId,
    );
    if (isClosed) return null;
    if (result.isOk) {
      _replaceByKey(key, result.valueOrNull!);
      _emitLoaded();
      return null;
    }
    _removeByKey(key);
    _emitLoaded();
    return result.failureOrNull;
  }

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

  Future<AppFailure?> deleteComment(Comment comment) async {
    final topSnapshot = [..._topLevel];
    final repliesSnapshot = {
      for (final e in _repliesByParent.entries) e.key: [...e.value],
    };
    _remove(comment);
    _emitLoaded();
    final result = await _deleteComment(comment.id, reelId: _reelId);
    if (isClosed) return null;
    if (result.isOk) {
      _emitLoaded();
      return null;
    }
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

  // ---- Internals (mirror #006 list management) ------------------------------

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
    final comments = _buildDisplay();
    emit(
      paginating
          ? CommentsState.loadedPaginating(
              post: null,
              comments: comments,
              hasMore: _hasMore,
              nextCursor: _cursor,
              replyContext: _replyContext,
            )
          : CommentsState.loaded(
              post: null,
              comments: comments,
              hasMore: _hasMore,
              nextCursor: _cursor,
              replyContext: _replyContext,
            ),
    );
  }
}
