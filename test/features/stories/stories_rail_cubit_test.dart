import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/fake_stories_repository.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

/// US4 — stories rail: "Your story" leads, unseen reels (gradient ring) ordered
/// before seen, ring recomputes live as segments are marked seen.
StoriesRailCubit _cubitFor(FakeStoriesRepository repo) => StoriesRailCubit(
  LoadStoryReels(repo),
  WatchSeenSegments(repo),
);

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  late AppDatabase db;
  late FakeStoriesRepository repo;
  late StoriesRailCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeStoriesRepository(db, OwnStoryStore());
    cubit = _cubitFor(repo);
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('loads reels with "Your story" first', () async {
    await cubit.load();
    final reels = cubit.state.dataOrNull!;
    expect(reels, isNotEmpty);
    expect(reels.first.isYou, isTrue);
  });

  test('unseen reels are ordered ahead of seen ones', () async {
    // Mark all of the first non-you reel's segments seen.
    await cubit.load();
    final reels = cubit.state.dataOrNull!;
    final target = reels.firstWhere((r) => !r.isYou);
    for (final seg in target.segments) {
      await repo.markSegmentSeen(seg.id, target.authorId);
    }
    await _settle();

    final ordered = cubit.state.dataOrNull!;
    // "Your story" still first; the now-seen reel sinks below unseen reels.
    expect(ordered.first.isYou, isTrue);
    final others = ordered.where((r) => !r.isYou).toList();
    final firstSeenIdx = others.indexWhere((r) => !r.hasUnseen);
    final lastUnseenIdx = others.lastIndexWhere((r) => r.hasUnseen);
    expect(firstSeenIdx, greaterThan(lastUnseenIdx));
  });

  test('ring recomputes live when a segment is marked seen', () async {
    await cubit.load();
    final target = cubit.state.dataOrNull!.firstWhere((r) => !r.isYou);
    expect(target.hasUnseen, isTrue);

    for (final seg in target.segments) {
      await repo.markSegmentSeen(seg.id, target.authorId);
    }
    await _settle();

    final updated = cubit.state.dataOrNull!.firstWhere(
      (r) => r.authorId == target.authorId,
    );
    expect(updated.hasUnseen, isFalse);
  });
}
