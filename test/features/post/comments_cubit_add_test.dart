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
  });

  tearDown(() => cubit.close());

  test(
    'add appears optimistically, then confirms, bumping the count',
    () async {
      cubit = buildCommentsCubit(
        comments,
        FakeFeed({'post-001': fakePost('post-001', commentCount: 5)}),
      );
      await cubit.load('post-001');
      final base = cubit.state.comments.length;
      final baseCount = cubit.state.post!.commentCount;

      final future = cubit.addComment('great shot');
      // Optimistic: the pending comment is visible immediately (SC-002).
      expect(
        cubit.state.comments.any((c) => c.pending && c.text == 'great shot'),
        isTrue,
      );
      expect(cubit.state.post!.commentCount, baseCount + 1);

      final failure = await future;
      expect(failure, isNull);
      // Confirmed: same one comment, no longer pending, count still +1.
      expect(cubit.state.comments.length, base + 1);
      expect(
        cubit.state.comments.where((c) => c.text == 'great shot').length,
        1,
      );
      expect(
        cubit.state.comments.any((c) => c.text == 'great shot' && c.pending),
        isFalse,
      );
      expect(cubit.state.post!.commentCount, baseCount + 1);
    },
  );

  test('add failure rolls back the comment and the count', () async {
    cubit = buildCommentsCubit(
      comments,
      FakeFeed({'post-001': fakePost('post-001', commentCount: 5)}),
    );
    await cubit.load('post-001');
    final base = cubit.state.comments.length;
    final baseCount = cubit.state.post!.commentCount;

    comments.failNextAdd = true;
    final failure = await cubit.addComment('nope');
    expect(failure, isNotNull);
    expect(cubit.state.comments.length, base);
    expect(cubit.state.comments.any((c) => c.text == 'nope'), isFalse);
    expect(cubit.state.post!.commentCount, baseCount);
  });

  test('empty / whitespace text is a no-op', () async {
    cubit = buildCommentsCubit(
      comments,
      FakeFeed({'post-001': fakePost('post-001')}),
    );
    await cubit.load('post-001');
    final base = cubit.state.comments.length;
    final failure = await cubit.addComment('   ');
    expect(failure, isNull);
    expect(cubit.state.comments.length, base);
  });

  test(
    'commentsDisabled is reflected in state (input hidden by the page)',
    () async {
      cubit = buildCommentsCubit(
        comments,
        FakeFeed({'p': fakePost('p', commentsDisabled: true, commentCount: 0)}),
      );
      await cubit.load('p');
      expect(cubit.state.commentsDisabled, isTrue);
    },
  );
}
