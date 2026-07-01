import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/fake_stories_repository.dart';

void main() {
  late AppDatabase db;
  late FakeStoriesRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeStoriesRepository(db);
  });
  tearDown(() => db.close());

  test('synthesizes reels including a "Your story" self reel', () async {
    final result = await repo.loadReels();
    expect(result.isOk, isTrue);
    final reels = result.valueOrNull!;
    expect(reels.any((r) => r.isYou), isTrue);
    expect(reels.every((r) => r.segments.isNotEmpty), isTrue);
  });

  test(
    'all reels start unseen; marking a segment persists seen-state',
    () async {
      final reels = (await repo.loadReels()).valueOrNull!;
      expect(reels.every((r) => r.hasUnseen), isTrue);

      final target = reels.firstWhere((r) => !r.isYou);
      await repo.markSegmentSeen(target.segments.first.id, target.authorId);

      final seen = await repo.watchSeen().first;
      expect(seen, contains(target.segments.first.id));
    },
  );

  test('likeSegment toggles in-memory like state', () async {
    final reels = (await repo.loadReels()).valueOrNull!;
    final seg = reels.first.segments.first;
    await repo.likeSegment(seg.id, like: true);

    final after = (await repo.loadReels()).valueOrNull!;
    final liked = after
        .expand((r) => r.segments)
        .firstWhere((s) => s.id == seg.id);
    expect(liked.viewerHasLiked, isTrue);
  });
}
