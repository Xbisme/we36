import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/features/explore/domain/usecases/discovery_page_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_state.dart';

/// #009 US4 (T045): hashtag/place first+next page, header meta, error.
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;

  DiscoveryGridCubit build() =>
      DiscoveryGridCubit(LoadHashtagPage(repo), LoadPlacePage(repo));

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
  });

  tearDown(() => db.close());

  test('hashtag page loads header + grid', () async {
    final cubit = build();
    await cubit.initHashtag('travel');
    final s = cubit.state as DiscoveryGridLoaded;
    expect(s.kind, DiscoveryPageKind.hashtag);
    expect(s.title, '#travel');
    expect(s.postCount, greaterThan(0));
    expect(s.items, isNotEmpty);
    await cubit.close();
  });

  test('place page loads header + grid', () async {
    final cubit = build();
    await cubit.initPlace('place-da-nang');
    final s = cubit.state as DiscoveryGridLoaded;
    expect(s.kind, DiscoveryPageKind.place);
    expect(s.title, 'Da Nang');
    expect(s.items, isNotEmpty);
    await cubit.close();
  });

  test('loadMore appends the next page', () async {
    final cubit = build();
    await cubit.initHashtag('travel');
    final firstCount = cubit.state.items.length;
    await cubit.loadMore();
    expect(cubit.state.items.length, greaterThan(firstCount));
    await cubit.close();
  });

  test('a failed load surfaces an error', () async {
    repo.failNextQuery = true;
    final cubit = build();
    await cubit.initHashtag('travel');
    expect(cubit.state, isA<DiscoveryGridError>());
    await cubit.close();
  });
}
