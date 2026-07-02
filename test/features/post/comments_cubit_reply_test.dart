import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';

import '../../helpers/comment_test_doubles.dart';

void main() {
  late FakeCommentsRepository comments;
  late CommentsCubit cubit;

  setUp(() {
    comments = FakeCommentsRepository(
      clock: () => DateTime.utc(2026, 7, 2, 12),
    );
    cubit = buildCommentsCubit(
      comments,
      FakeFeed({'post-001': fakePost('post-001', commentCount: 5)}),
    );
  });

  tearDown(() => cubit.close());

  test('reply attaches under its parent (one level)', () async {
    await cubit.load('post-001');
    final parent = cubit.state.comments.firstWhere((c) => c.parentId == null);

    cubit.startReply(parent);
    expect(cubit.state.replyContext!.parentId, parent.id);

    final failure = await cubit.addComment('nice one');
    expect(failure, isNull);
    final reply = cubit.state.comments.firstWhere((c) => c.text == 'nice one');
    expect(reply.parentId, parent.id);
    expect(reply.isReply, isTrue);
    // Reply-context cleared after posting.
    expect(cubit.state.replyContext, isNull);
  });

  test('replying to a reply normalizes to the top-level ancestor', () async {
    await cubit.load('post-001');
    final parent = cubit.state.comments.firstWhere((c) => c.replyCount > 0);
    final existingReply = cubit.state.comments.firstWhere(
      (c) => c.parentId == parent.id,
    );

    cubit.startReply(existingReply);
    // The context targets the ancestor, never the reply itself (SC-007).
    expect(cubit.state.replyContext!.parentId, parent.id);

    await cubit.addComment('deep');
    final deep = cubit.state.comments.firstWhere((c) => c.text == 'deep');
    expect(deep.parentId, parent.id); // one level only
  });

  test('cancelReply returns to top-level composing', () async {
    await cubit.load('post-001');
    final parent = cubit.state.comments.firstWhere((c) => c.parentId == null);
    cubit.startReply(parent);
    expect(cubit.state.replyContext, isNotNull);
    cubit.cancelReply();
    expect(cubit.state.replyContext, isNull);
  });
}
