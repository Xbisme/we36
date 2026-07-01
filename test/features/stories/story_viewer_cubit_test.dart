import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/fake_stories_repository.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';
import 'package:we36/features/stories/presentation/story_viewer_cubit.dart';

/// US5 — story viewer playback: navigation across segments/reels, seen
/// persistence, and optimistic like.
StoryViewerCubit _cubitFor(FakeStoriesRepository repo) => StoryViewerCubit(
  MarkSegmentSeen(repo),
  LikeStorySegment(repo),
);

List<StoryReel> _reels() {
  StorySegment seg(String author, int i) => StorySegment(
    id: '$author-$i',
    authorId: author,
    imageUrl: 'https://x/$author-$i.jpg',
    durationMs: 5000,
    position: i,
    createdAt: DateTime.utc(2026, 7),
  );
  return [
    StoryReel(
      authorId: 'a',
      username: 'a',
      segments: [seg('a', 0), seg('a', 1)],
      hasUnseen: true,
      latestAt: DateTime.utc(2026, 7),
    ),
    StoryReel(
      authorId: 'b',
      username: 'b',
      segments: [seg('b', 0)],
      hasUnseen: true,
      latestAt: DateTime.utc(2026, 7),
    ),
  ];
}

void main() {
  late AppDatabase db;
  late FakeStoriesRepository repo;
  late StoryViewerCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeStoriesRepository(db, OwnStoryStore());
    cubit = _cubitFor(repo);
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('next advances segment, then next reel, then closes', () async {
    cubit.open(_reels(), 0);
    expect(cubit.state.reelIndex, 0);
    expect(cubit.state.segmentIndex, 0);

    cubit.next(); // reel a, segment 1
    expect(cubit.state.segmentIndex, 1);

    cubit.next(); // reel b, segment 0
    expect(cubit.state.reelIndex, 1);
    expect(cubit.state.segmentIndex, 0);

    cubit.next(); // no more → close
    expect(cubit.state.closed, isTrue);
  });

  test('previous steps back a segment, then to the previous reel', () async {
    cubit
      ..open(_reels(), 1) // reel b
      ..previous(); // back to reel a's last segment
    expect(cubit.state.reelIndex, 0);
    expect(cubit.state.segmentIndex, 1);
  });

  test('pause/resume toggles the paused flag', () async {
    cubit
      ..open(_reels(), 0)
      ..pause();
    expect(cubit.state.paused, isTrue);
    cubit.resume();
    expect(cubit.state.paused, isFalse);
  });

  test('opening marks the current segment seen (persists)', () async {
    cubit.open(_reels(), 0);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final seen = await repo.watchSeen().first;
    expect(seen, contains('a-0'));
  });

  test('likeCurrent flips the current segment optimistically', () async {
    cubit.open(_reels(), 0);
    expect(cubit.state.currentSegment!.viewerHasLiked, isFalse);
    await cubit.likeCurrent();
    expect(cubit.state.currentSegment!.viewerHasLiked, isTrue);
  });

  test('an empty reel set opens as unavailable + closed (FR-028)', () async {
    cubit.open(const [], 0);
    expect(cubit.state.unavailable, isTrue);
    expect(cubit.state.closed, isTrue);
  });
}
