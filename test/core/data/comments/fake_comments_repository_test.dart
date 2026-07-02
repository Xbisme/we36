import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/fake_comments_repository.dart';

void main() {
  late FakeCommentsRepository repo;

  setUp(() {
    repo = FakeCommentsRepository(clock: () => DateTime.utc(2026, 7, 2, 12));
  });

  group('loadComments', () {
    test('pages oldest-first, top-level only, with a working cursor', () async {
      final first = (await repo.loadComments('post-000')).valueOrNull!;
      expect(first.items.length, 20);
      expect(first.hasMore, isTrue);
      expect(first.nextCursor, '20');
      // Top-level only (replies excluded from the top list).
      expect(first.items.every((c) => c.parentId == null), isTrue);
      // Ascending createdAt.
      for (var i = 1; i < first.items.length; i++) {
        expect(
          first.items[i].createdAt.isAfter(first.items[i - 1].createdAt),
          isTrue,
        );
      }
      final second = (await repo.loadComments(
        'post-000',
        cursor: first.nextCursor,
      )).valueOrNull!;
      expect(second.items.length, 5); // 25 top-level total
      expect(second.hasMore, isFalse);
    });

    test('empty post yields an empty page', () async {
      final page = (await repo.loadComments('post-004')).valueOrNull!;
      expect(page.items, isEmpty);
      expect(page.hasMore, isFalse);
    });
  });

  test("loadReplies returns a parent's replies (one level)", () async {
    // Seed the post, then read replies of its first top-level comment.
    final top = (await repo.loadComments('post-001')).valueOrNull!;
    final withReplies = top.items.firstWhere((c) => c.replyCount > 0);
    final replies = (await repo.loadReplies(withReplies.id)).valueOrNull!;
    expect(replies.items.length, withReplies.replyCount);
    expect(replies.items.every((c) => c.parentId == withReplies.id), isTrue);
  });

  group('addComment', () {
    test('appends and bumps the parent replyCount for a reply', () async {
      final top = (await repo.loadComments('post-001')).valueOrNull!;
      final parent = top.items.first;
      final before = parent.replyCount;
      final added = (await repo.addComment(
        'post-001',
        text: 'nice',
        clientKey: 'k1',
        parentId: parent.id,
      )).valueOrNull!;
      expect(added.parentId, parent.id);
      final replies = (await repo.loadReplies(parent.id)).valueOrNull!;
      expect(replies.items.length, before + 1);
    });

    test('reply-to-a-reply normalizes to the top-level ancestor', () async {
      final top = (await repo.loadComments('post-001')).valueOrNull!;
      final parent = top.items.firstWhere((c) => c.replyCount > 0);
      final reply = (await repo.loadReplies(parent.id)).valueOrNull!.items.first;
      final added = (await repo.addComment(
        'post-001',
        text: 'deep',
        clientKey: 'k2',
        parentId: reply.id,
      )).valueOrNull!;
      expect(added.parentId, parent.id); // never the reply id (one level)
    });

    test('is idempotent — same key returns the same comment', () async {
      final a = (await repo.addComment(
        'post-001',
        text: 'hi',
        clientKey: 'dupe',
      )).valueOrNull!;
      final b = (await repo.addComment(
        'post-001',
        text: 'hi again',
        clientKey: 'dupe',
      )).valueOrNull!;
      expect(b.id, a.id);
      expect(b.text, a.text); // the first write wins
    });

    test('failure then same-key retry yields exactly one comment', () async {
      repo.failNextAdd = true;
      final fail = await repo.addComment('post-001', text: 'x', clientKey: 'r');
      expect(fail.isOk, isFalse);
      final ok = await repo.addComment('post-001', text: 'x', clientKey: 'r');
      expect(ok.isOk, isTrue);
      final again = await repo.addComment('post-001', text: 'x', clientKey: 'r');
      expect(again.valueOrNull!.id, ok.valueOrNull!.id); // one comment
    });
  });

  test('toggleCommentLike is target-state (idempotent)', () async {
    final top = (await repo.loadComments('post-001')).valueOrNull!;
    final c = top.items.firstWhere((c) => !c.viewerHasLiked);
    final liked = (await repo.toggleCommentLike(c.id, like: true)).valueOrNull!;
    expect(liked.viewerHasLiked, isTrue);
    expect(liked.likeCount, c.likeCount + 1);
    // Same-direction repeat is a no-op on the count.
    final again =
        (await repo.toggleCommentLike(c.id, like: true)).valueOrNull!;
    expect(again.likeCount, c.likeCount + 1);
    final unliked =
        (await repo.toggleCommentLike(c.id, like: false)).valueOrNull!;
    expect(unliked.viewerHasLiked, isFalse);
    expect(unliked.likeCount, c.likeCount);
  });

  group('deleteComment', () {
    test('top-level cascade removes replies and returns 1+replyCount', () async {
      final top = (await repo.loadComments('post-001')).valueOrNull!;
      final parent = top.items.firstWhere((c) => c.replyCount > 0);
      final removed =
          (await repo.deleteComment(parent.id)).valueOrNull!;
      expect(removed, 1 + parent.replyCount);
      final after = (await repo.loadComments('post-001')).valueOrNull!;
      expect(after.items.any((c) => c.id == parent.id), isFalse);
      final replies = (await repo.loadReplies(parent.id)).valueOrNull!;
      expect(replies.items, isEmpty);
    });

    test('reply delete returns 1 and decrements the parent replyCount',
        () async {
      final top = (await repo.loadComments('post-001')).valueOrNull!;
      final parent = top.items.firstWhere((c) => c.replyCount > 0);
      final reply = (await repo.loadReplies(parent.id)).valueOrNull!.items.first;
      final removed = (await repo.deleteComment(reply.id)).valueOrNull!;
      expect(removed, 1);
      final after = (await repo.loadComments('post-001')).valueOrNull!;
      final parentAfter = after.items.firstWhere((c) => c.id == parent.id);
      expect(parentAfter.replyCount, parent.replyCount - 1);
    });

    test('deleting a missing comment is a no-op (0)', () async {
      final removed = (await repo.deleteComment('nope')).valueOrNull!;
      expect(removed, 0);
    });
  });

  test('reportComment acknowledges without changing state', () async {
    final result = await repo.reportComment('post-001-c00');
    expect(result.isOk, isTrue);
  });
}
