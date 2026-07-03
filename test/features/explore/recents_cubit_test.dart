import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/features/explore/domain/usecases/recents_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/recents_state.dart';

/// #009 US3 (T040): record dedupe-and-promote, delete one, clear all (optimistic).
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;
  late RecentsCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
    cubit = RecentsCubit(
      GetRecents(repo),
      RecordRecent(repo),
      DeleteRecent(repo),
      ClearRecents(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('record promotes an existing term instead of duplicating', () async {
    await cubit.load();
    await cubit.record(RecordSearchRecent.term('sunset'));
    await cubit.record(RecordSearchRecent.hashtag('travel'));
    await cubit.record(RecordSearchRecent.term('sunset')); // repeat

    final items = cubit.state.items;
    expect(items, hasLength(2)); // no duplicate
    expect(items.first.term, 'sunset'); // promoted to top
  });

  test('delete removes one (optimistic)', () async {
    await cubit.load();
    await cubit.record(RecordSearchRecent.term('a'));
    await cubit.record(RecordSearchRecent.term('b'));
    final second = cubit.state.items.firstWhere((r) => r.term == 'b');
    await cubit.deleteRecent(second.id);
    expect(cubit.state.items.map((r) => r.term), ['a']);
  });

  test('clear all empties the list (optimistic)', () async {
    await cubit.load();
    await cubit.record(RecordSearchRecent.term('a'));
    await cubit.clearAll();
    expect(cubit.state.items, isEmpty);
  });

  test('load surfaces an error when the source fails', () async {
    repo.failNextQuery = true;
    await cubit.load();
    expect(cubit.state, isA<RecentsError>());
  });
}
