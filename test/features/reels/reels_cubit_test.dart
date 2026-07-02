import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/fake_reels_repository.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/reels/domain/usecases/reel_engagement_usecases.dart';
import 'package:we36/features/reels/domain/usecases/reel_feed_usecases.dart';
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reels_state.dart';

class _MockReelsRepository extends Mock implements ReelsRepository {}

ReelsCubit _cubitFor(ReelsRepository repo) => ReelsCubit(
  WatchReelsFeed(repo),
  LoadReels(repo),
  LoadMoreReels(repo),
  ToggleReelLike(repo),
  ToggleReelSave(repo),
);

void main() {
  group('ReelsCubit (fake-backed)', () {
    late AppDatabase db;
    late FakeReelsRepository repo;
    late ReelsCubit cubit;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = FakeReelsRepository(db)..processingDelay = Duration.zero;
      cubit = _cubitFor(repo);
    });
    tearDown(() async {
      await cubit.close();
      await db.close();
    });

    test('loadInitial loads the first page into a loaded state', () async {
      await cubit.loadInitial();
      expect(cubit.state, isA<ReelsLoaded>());
      expect(cubit.state.reels, hasLength(6));
      expect(cubit.state.hasMore, isTrue);
    });

    test('loadMore appends the next page', () async {
      await cubit.loadInitial();
      await cubit.loadMore();
      expect(cubit.state, isA<ReelsLoaded>());
      expect(cubit.state.reels, hasLength(12));
    });

    test('refresh keeps a populated loaded state', () async {
      await cubit.loadInitial();
      await cubit.refresh();
      expect(cubit.state, isA<ReelsLoaded>());
      expect(cubit.state.reels, hasLength(6));
    });
  });

  group('ReelsCubit (mocked failure)', () {
    setUpAll(() {
      registerFallbackValue(PageRequest());
    });

    blocTest<ReelsCubit, ReelsState>(
      'emits error when the first page fails with no cache',
      build: () {
        final repo = _MockReelsRepository();
        when(repo.watchReelsFeed).thenAnswer((_) => Stream.value(const []));
        when(repo.loadFirstPage).thenAnswer(
          (_) async => const Result<CursorPage<Reel>>.err(
            AppFailure.networkError(),
          ),
        );
        return _cubitFor(repo);
      },
      act: (cubit) => cubit.loadInitial(),
      expect: () => [isA<ReelsLoading>(), isA<ReelsError>()],
    );
  });
}
