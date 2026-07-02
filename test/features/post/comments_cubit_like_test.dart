import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/comment.dart';
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

  Comment find(String id) => cubit.state.comments.firstWhere((c) => c.id == id);

  test('like flips optimistically and reconciles to server state', () async {
    await cubit.load('post-001');
    final target = cubit.state.comments.firstWhere((c) => !c.viewerHasLiked);
    final before = target.likeCount;

    await cubit.toggleLike(target);
    final after = find(target.id);
    expect(after.viewerHasLiked, isTrue);
    expect(after.likeCount, before + 1);
  });

  test('like failure reverts', () async {
    await cubit.load('post-001');
    final target = cubit.state.comments.firstWhere((c) => !c.viewerHasLiked);
    final before = target.likeCount;

    comments.failNextMutation = true;
    final failure = await cubit.toggleLike(target);
    expect(failure, isNotNull);
    final after = find(target.id);
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, before);
  });

  test('like then unlike settles to unliked (target-state)', () async {
    await cubit.load('post-001');
    final target = cubit.state.comments.firstWhere((c) => !c.viewerHasLiked);
    final before = target.likeCount;

    await cubit.toggleLike(target);
    await cubit.toggleLike(find(target.id));
    final after = find(target.id);
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, before);
  });
}
