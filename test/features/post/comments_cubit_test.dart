import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';

import '../../helpers/comment_test_doubles.dart';

void main() {
  late FakeCommentsRepository comments;
  late FakeFeed feed;
  late CommentsCubit cubit;

  CommentsCubit build(Map<String, Post> posts) {
    feed = FakeFeed(posts);
    return buildCommentsCubit(comments, feed);
  }

  setUp(() {
    comments = FakeCommentsRepository(
      clock: () => DateTime.utc(2026, 7, 2, 12),
    );
  });

  tearDown(() => cubit.close());

  test(
    'load → loaded with oldest-first comments and interleaved replies',
    () async {
      cubit = build({'post-001': fakePost('post-001')});
      await cubit.load('post-001');
      final state = cubit.state;
      expect(state, isA<CommentsLoaded>());
      expect(state.post, isNotNull);
      expect(state.comments, isNotEmpty);
      // 5 top-level + 2 replies of the first = 7 display rows.
      expect(state.comments.length, 7);
      // A reply appears directly after its parent (indent one level).
      expect(state.comments[1].isReply, isTrue);
      expect(state.comments[1].parentId, state.comments[0].id);
    },
  );

  test('empty post → loaded with no comments', () async {
    cubit = build({'post-004': fakePost('post-004', commentCount: 0)});
    await cubit.load('post-004');
    expect(cubit.state, isA<CommentsLoaded>());
    expect(cubit.state.comments, isEmpty);
  });

  test('loadMore appends the next page', () async {
    cubit = build({'post-000': fakePost('post-000', commentCount: 25)});
    await cubit.load('post-000');
    final firstCount = cubit.state.comments.length;
    expect(cubit.state.hasMore, isTrue); // 25 top-level > page size 20
    await cubit.loadMore();
    expect(cubit.state.comments.length, greaterThan(firstCount));
    expect(cubit.state.hasMore, isFalse);
  });

  test('first-load failure → error, retry → loaded', () async {
    cubit = build({'post-001': fakePost('post-001')});
    comments.failNextLoad = true;
    await cubit.load('post-001');
    expect(cubit.state, isA<CommentsError>());
    await cubit.retry();
    expect(cubit.state, isA<CommentsLoaded>());
    expect(cubit.state.comments, isNotEmpty);
  });
}
