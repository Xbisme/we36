import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/features/explore/domain/usecases/search_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/search_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/search_state.dart';

/// #009 US1 (T025): search invocation model (live, ≥2 chars, debounced),
/// latest-term-wins, Top snapshot, tab switch + pagination, error.
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;
  late SearchCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
    cubit = SearchCubit(
      SearchTopQuery(repo),
      SearchAccounts(repo),
      SearchTags(repo),
      SearchPlaces(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('below 2 chars stays initial (recents shown, no query)', () async {
    cubit.onQueryChanged('a');
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(cubit.state, isA<SearchInitial>());
  });

  test('submit runs immediately and loads the Top snapshot', () async {
    await cubit.submit('ali');
    final s = cubit.state;
    expect(s, isA<SearchLoaded>());
    expect((s as SearchLoaded).top, isNotNull);
    expect(s.top!.accounts, isNotEmpty); // alice/alicia
  });

  test('debounced live typing eventually searches', () async {
    cubit.onQueryChanged('sun');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(cubit.state, isA<SearchLoaded>());
    expect(cubit.state.query, 'sun');
  });

  test('latest term wins (stale results ignored)', () async {
    await cubit.submit('ali');
    await cubit.submit('bob');
    expect(cubit.state.query, 'bob');
  });

  test('changeTab lazily loads accounts and switches', () async {
    await cubit.submit('ali');
    await cubit.changeTab(SearchTab.accounts);
    final s = cubit.state as SearchLoaded;
    expect(s.tab, SearchTab.accounts);
    expect(s.accounts, isNotEmpty);
  });

  test('a failed fresh search surfaces an error', () async {
    repo.failNextQuery = true;
    await cubit.submit('ali');
    expect(cubit.state, isA<SearchError>());
  });
}
