import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/reels/fake_reels_repository.dart';
import 'package:we36/features/reels/domain/usecases/reel_engagement_usecases.dart';
import 'package:we36/features/reels/domain/usecases/reel_feed_usecases.dart';
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart';

ReelsCubit _cubitFor(FakeReelsRepository repo) => ReelsCubit(
  WatchReelsFeed(repo),
  LoadReels(repo),
  LoadMoreReels(repo),
  ToggleReelLike(repo),
  ToggleReelSave(repo),
  DeleteReel(repo),
);

void main() {
  late AppDatabase db;
  late FakeReelsRepository repo;
  late ReelsCubit cubit;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeReelsRepository(db)..processingDelay = Duration.zero;
    cubit = _cubitFor(repo);
    await cubit.loadInitial();
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('toggleLike flips the canonical reel optimistically', () async {
    final reel = cubit.state.reels.first;
    expect(reel.viewerHasLiked, isFalse);
    final result = await cubit.toggleLike(reel);
    expect(result.isOk, isTrue);
    await pumpEventQueue(); // let the canonical stream propagate to the cubit
    final after = cubit.state.reels.firstWhere((r) => r.id == reel.id);
    expect(after.viewerHasLiked, isTrue);
    expect(after.likeCount, reel.likeCount + 1);
  });

  test('toggleSave flips the canonical reel optimistically', () async {
    final reel = cubit.state.reels.first;
    final result = await cubit.toggleSave(reel);
    expect(result.isOk, isTrue);
    await pumpEventQueue();
    final after = cubit.state.reels.firstWhere((r) => r.id == reel.id);
    expect(after.viewerHasSaved, isTrue);
    expect(after.saveCount, reel.saveCount + 1);
  });

  test('a failed like rolls back (no stuck optimistic state)', () async {
    final reel = cubit.state.reels.first;
    repo.failNextMutation = true;
    final result = await cubit.toggleLike(reel);
    expect(result.isErr, isTrue);
    await pumpEventQueue();
    final after = cubit.state.reels.firstWhere((r) => r.id == reel.id);
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, reel.likeCount);
  });

  test('deleteReel removes the reel from the feed', () async {
    final reel = cubit.state.reels.first;
    final result = await cubit.deleteReel(reel);
    expect(result.isOk, isTrue);
    await pumpEventQueue();
    expect(cubit.state.reels.any((r) => r.id == reel.id), isFalse);
  });
}
