import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/fake_collections_repository.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_state.dart';

void main() {
  late FakeCollectionsRepository repo;
  late SaveToCollectionCubit cubit;

  setUp(() {
    repo = FakeCollectionsRepository();
    cubit = SaveToCollectionCubit(
      LoadPicker(repo),
      FileIntoCollection(repo),
      UnfileFromCollection(repo),
      CreateCollection(repo),
    );
  });
  tearDown(() async {
    await cubit.close();
    repo.dispose();
  });

  Future<String> aSavedPostNotInFood() async {
    final all = (await repo.allSaved()).valueOrNull!.items
        .map((e) => e.id)
        .toSet();
    final food = (await repo.collectionItems(
      'col_food',
    )).valueOrNull!.items.map((e) => e.id).toSet();
    return all.difference(food).first;
  }

  test('loads membership with a picker row per named collection', () async {
    final postId = await aSavedPostNotInFood();
    await cubit.load(postId);
    final s = cubit.state as SaveToCollectionLoaded;
    expect(
      s.membership.collections.map((r) => r.collection.name),
      contains('Food'),
    );
    expect(s.membership.namedMembershipCount, 0);
  });

  test(
    'toggle files the post into a collection (optimistic, then persisted)',
    () async {
      final postId = await aSavedPostNotInFood();
      await cubit.load(postId);

      final ok = await cubit.toggle('col_food', currentlyContains: false);

      expect(ok, isTrue);
      final s = cubit.state as SaveToCollectionLoaded;
      final food = s.membership.collections.firstWhere(
        (r) => r.collection.id == 'col_food',
      );
      expect(food.contains, isTrue);
      expect(s.membership.namedMembershipCount, 1);
    },
  );

  test('a failed toggle rolls back and returns false', () async {
    final postId = await aSavedPostNotInFood();
    await cubit.load(postId);
    repo.failNextMutation = true;

    final ok = await cubit.toggle('col_food', currentlyContains: false);

    expect(ok, isFalse);
    final s = cubit.state as SaveToCollectionLoaded;
    final food = s.membership.collections.firstWhere(
      (r) => r.collection.id == 'col_food',
    );
    expect(food.contains, isFalse); // reverted
  });

  test(
    'createAndFile creates a collection and files the post into it',
    () async {
      final postId = await aSavedPostNotInFood();
      await cubit.load(postId);

      final ok = await cubit.createAndFile('New Board');

      expect(ok, isTrue);
      final s = cubit.state as SaveToCollectionLoaded;
      final board = s.membership.collections.firstWhere(
        (r) => r.collection.name == 'New Board',
      );
      expect(board.contains, isTrue);
    },
  );
}
