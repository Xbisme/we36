import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';

import '../../helpers/comment_test_doubles.dart';

/// SC-005: the post's `commentCount` shown in the detail must match the
/// canonical cached post (what the feed reads) after every add/delete — one
/// canonical representation, no divergence.
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

  test('add then delete keeps detail count == canonical feed count', () async {
    await cubit.load('post-001');
    final base = feed.current('post-001')!.commentCount;

    // Add → both the detail state and the canonical post reflect +1.
    await cubit.addComment('hi');
    expect(cubit.state.post!.commentCount, base + 1);
    expect(feed.current('post-001')!.commentCount, base + 1);
    expect(
      cubit.state.post!.commentCount,
      feed.current('post-001')!.commentCount,
    );

    // Delete the just-added comment → back to base, still consistent.
    final added = cubit.state.comments.firstWhere((c) => c.text == 'hi');
    await cubit.deleteComment(added);
    expect(cubit.state.post!.commentCount, base);
    expect(feed.current('post-001')!.commentCount, base);
  });

  test(
    'deleting a top-level comment with replies decrements by 1+replies',
    () async {
      await cubit.load('post-001');
      final base = feed.current('post-001')!.commentCount;
      // The first seeded top-level comment has 2 replies.
      final parent = cubit.state.comments.firstWhere((c) => c.replyCount > 0);
      await cubit.deleteComment(parent);
      expect(feed.current('post-001')!.commentCount, base - (1 + 2));
      expect(
        cubit.state.post!.commentCount,
        feed.current('post-001')!.commentCount,
      );
    },
  );
}
