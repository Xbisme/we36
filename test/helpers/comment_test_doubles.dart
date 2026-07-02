import 'dart:async';

import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/features/post/domain/usecases/comment_usecases.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';

/// A canonical [Post] fixture for post-detail tests.
Post fakePost(
  String id, {
  bool commentsDisabled = false,
  int commentCount = 3,
}) => Post(
  id: id,
  author: const UserSummary(
    id: 'user-maya',
    username: 'maya',
    isVerified: false,
  ),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: commentsDisabled,
  likeCount: 10,
  saveCount: 1,
  commentCount: commentCount,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7, 1, 12),
  caption: 'hello',
);

/// Minimal in-memory [FeedRepository] for post-detail tests — only `watchPost`
/// + `applyCommentCountDelta` are exercised by [CommentsCubit]. Re-emits the
/// canonical post on a count delta so consistency is observable.
class FakeFeed implements FeedRepository {
  FakeFeed(this.posts);
  final Map<String, Post> posts;
  final List<MapEntry<String, StreamController<Post?>>> _controllers = [];

  Post? current(String id) => posts[id];

  @override
  Stream<Post?> watchPost(String id) {
    final c = StreamController<Post?>()..add(posts[id]);
    final entry = MapEntry(id, c);
    _controllers.add(entry);
    c.onCancel = () => _controllers.remove(entry);
    return c.stream;
  }

  @override
  Future<void> applyCommentCountDelta(String id, int delta) async {
    final p = posts[id];
    if (p == null) return;
    posts[id] = p.copyWith(
      commentCount: (p.commentCount + delta).clamp(0, 1 << 30),
    );
    for (final e in _controllers) {
      if (e.key == id && !e.value.isClosed) e.value.add(posts[id]);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

/// Builds a [CommentsCubit] wired to the shared fakes for tests.
CommentsCubit buildCommentsCubit(
  FakeCommentsRepository comments,
  FakeFeed feed,
) => CommentsCubit(
  WatchPost(feed),
  LoadComments(comments),
  LoadReplies(comments),
  AddComment(comments, feed),
  ToggleCommentLike(comments),
  DeleteComment(comments, feed),
  ReportComment(comments),
  IdempotencyKeys(),
);
