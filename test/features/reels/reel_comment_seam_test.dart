import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comments_repository.dart';
import 'package:we36/core/data/reels/fake_reels_repository.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/reels/domain/usecases/reel_comment_usecases.dart';

class _MockCommentsRepository extends Mock implements CommentsRepository {}

Comment _comment(String id) => Comment(
  id: id,
  postId: 'reel-000',
  author: const CommentAuthor(id: 'user-me', username: 'you', isVerified: false),
  text: 'nice',
  createdAt: DateTime.utc(2026, 7),
  likeCount: 0,
  viewerHasLiked: false,
  isOwn: true,
);

void main() {
  late AppDatabase db;
  late FakeReelsRepository reels;
  late _MockCommentsRepository comments;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reels = FakeReelsRepository(db)..processingDelay = Duration.zero;
    comments = _MockCommentsRepository();
    await reels.loadFirstPage();
  });
  tearDown(() => db.close());

  test('AddReelComment bumps the canonical reel commentCount by +1', () async {
    final before = (await reels.watchReelsFeed().first).firstWhere(
      (r) => r.id == 'reel-000',
    );
    when(
      () => comments.addComment(
        any(),
        text: any(named: 'text'),
        clientKey: any(named: 'clientKey'),
        parentId: any(named: 'parentId'),
      ),
    ).thenAnswer((_) async => Result.ok(_comment('c1')));

    final result = await AddReelComment(comments, reels).call(
      'reel-000',
      text: 'nice',
      clientKey: 'k1',
    );
    expect(result.isOk, isTrue);

    final after = (await reels.watchReelsFeed().first).firstWhere(
      (r) => r.id == 'reel-000',
    );
    expect(after.commentCount, before.commentCount + 1);
  });

  test('DeleteReelComment decrements by the number removed', () async {
    // Seed a +2 count first via the repo cache.
    await reels.applyCommentCountDelta('reel-000', 2);
    final before = (await reels.watchReelsFeed().first).firstWhere(
      (r) => r.id == 'reel-000',
    );
    when(() => comments.deleteComment(any()))
        .thenAnswer((_) async => const Result.ok(2));

    final result = await DeleteReelComment(comments, reels).call(
      'c1',
      reelId: 'reel-000',
    );
    expect(result.valueOrNull, 2);

    final after = (await reels.watchReelsFeed().first).firstWhere(
      (r) => r.id == 'reel-000',
    );
    expect(after.commentCount, before.commentCount - 2);
  });
}
