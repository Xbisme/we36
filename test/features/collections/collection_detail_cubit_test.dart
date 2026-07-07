import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/fake_collections_repository.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/features/collections/domain/usecases/collection_items_usecases.dart';
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_state.dart';

void main() {
  late FakeCollectionsRepository repo;
  late CollectionDetailCubit cubit;

  setUp(() {
    repo = FakeCollectionsRepository();
    cubit = CollectionDetailCubit(
      LoadCollectionItems(repo),
      UnfileFromCollection(repo),
      FullUnsave(repo),
    );
  });
  tearDown(() async {
    await cubit.close();
    repo.dispose();
  });

  test('loads a named collection items page', () async {
    await cubit.load('col_food');
    final s = cubit.state as CollectionDetailLoaded;
    expect(s.items, isNotEmpty);
    expect(s.items.length, 3); // Food seeded with 3
  });

  test('loads the "All saved" virtual view', () async {
    await cubit.load(kAllSavedCollectionId);
    final s = cubit.state as CollectionDetailLoaded;
    expect(s.items.length, 6); // 6 seeded saved items
  });

  test(
    'remove-from-collection drops the item but keeps it saved (SC-005)',
    () async {
      await cubit.load('col_food');
      final postId = (cubit.state as CollectionDetailLoaded).items.first.id;

      final ok = await cubit.removeFromCollection(postId);

      expect(ok, isTrue);
      final s = cubit.state as CollectionDetailLoaded;
      expect(s.items.map((i) => i.id), isNot(contains(postId)));
      // Still in "All saved".
      final all = (await repo.allSaved()).valueOrNull!.items.map((i) => i.id);
      expect(all, contains(postId));
    },
  );

  test('full unsave removes the item everywhere (SC-007)', () async {
    await cubit.load(kAllSavedCollectionId);
    final postId = (cubit.state as CollectionDetailLoaded).items.first.id;

    final ok = await cubit.fullUnsave(postId);

    expect(ok, isTrue);
    final all = (await repo.allSaved()).valueOrNull!.items.map((i) => i.id);
    expect(all, isNot(contains(postId)));
  });

  test('loads a page and loadMore appends without duplicates', () async {
    final all = (await repo.allSaved()).valueOrNull!.items.map((e) => e.id);
    for (final id in all) {
      await repo.file('col_trips', id);
    }
    await cubit.load('col_trips');
    final first = (cubit.state as CollectionDetailLoaded).items;
    expect(first.length, 6); // one full page

    await cubit.loadMore();
    final after = (cubit.state as CollectionDetailLoaded).items;
    // No duplicate ids after a further page request.
    expect(after.map((i) => i.id).toSet().length, after.length);
  });
}
