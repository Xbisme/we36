import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';

import '../../helpers/comment_test_doubles.dart';

void main() {
  late FakeCommentsRepository comments;
  late FakeFeed feed;
  late CommentsCubit cubit;

  setUp(() {
    comments = FakeCommentsRepository(
      clock: () => DateTime.utc(2026, 7, 2, 12),
    );
    feed = FakeFeed({'post-001': fakePost('post-001', commentCount: 5)});
    cubit = buildCommentsCubit(comments, feed);
  });

  tearDown(() => cubit.close());

  test('delete removes the comment and decrements the count', () async {
    await cubit.load('post-001');
    final base = cubit.state.comments.length;
    final target = cubit.state.comments.firstWhere((c) => c.parentId == null);
    final failure = await cubit.deleteComment(target);
    expect(failure, isNull);
    expect(cubit.state.comments.any((c) => c.id == target.id), isFalse);
    expect(cubit.state.comments.length, lessThan(base));
  });

  test('delete failure rolls back the removed comment', () async {
    await cubit.load('post-001');
    final base = cubit.state.comments.length;
    final target = cubit.state.comments.firstWhere((c) => c.parentId == null);
    final baseCount = cubit.state.post!.commentCount;

    comments.failNextMutation = true;
    final failure = await cubit.deleteComment(target);
    expect(failure, isNotNull);
    // Restored.
    expect(cubit.state.comments.any((c) => c.id == target.id), isTrue);
    expect(cubit.state.comments.length, base);
    expect(cubit.state.post!.commentCount, baseCount);
  });

  test('report acknowledges without mutating the list', () async {
    await cubit.load('post-001');
    final base = cubit.state.comments.length;
    final target = cubit.state.comments.first;
    final failure = await cubit.reportComment(target);
    expect(failure, isNull);
    expect(cubit.state.comments.length, base);
  });
}
