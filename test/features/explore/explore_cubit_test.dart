import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/features/explore/domain/usecases/explore_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/explore_state.dart';

/// #009 US2 (T034): load-first/next/refresh, reactive cache read, offline path.
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;

  ExploreCubit build() => ExploreCubit(
    WatchExplore(repo, BlockedUsersStore()),
    LoadExploreFirst(repo),
    LoadExploreNext(repo),
  );

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
  });

  tearDown(() => db.close());

  test('loadInitial renders the first page from the cache', () async {
    final cubit = build();
    await cubit.loadInitial();
    expect(cubit.state, isA<ExploreLoaded>());
    expect(cubit.state.items, hasLength(6));
    expect(cubit.state.hasMore, isTrue);
    await cubit.close();
  });

  test('loadMore appends the next page without duplicates', () async {
    final cubit = build();
    await cubit.loadInitial();
    await cubit.loadMore();
    expect(cubit.state.items, hasLength(12));
    expect(cubit.state.items.map((e) => e.id).toSet(), hasLength(12));
    await cubit.close();
  });

  test('a failed refresh keeps the cache and flags offline (FR-027)', () async {
    final cubit = build();
    await cubit.loadInitial(); // populate cache
    repo.failNextQuery = true;
    await cubit.refresh();
    final s = cubit.state as ExploreLoaded;
    expect(s.isOffline, isTrue);
    expect(s.items, hasLength(6)); // cache kept
    await cubit.close();
  });

  test('first-load error with an empty cache surfaces an error', () async {
    repo.failNextQuery = true;
    final cubit = build();
    await cubit.loadInitial();
    expect(cubit.state, isA<ExploreError>());
    await cubit.close();
  });
}
