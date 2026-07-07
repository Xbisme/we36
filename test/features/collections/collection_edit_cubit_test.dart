import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/fake_collections_repository.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collection_edit_cubit.dart';

void main() {
  late FakeCollectionsRepository repo;
  late CollectionEditCubit cubit;

  setUp(() {
    repo = FakeCollectionsRepository();
    cubit = CollectionEditCubit(
      CreateCollection(repo),
      RenameCollection(repo),
      DeleteCollection(repo),
      SetCollectionCover(repo),
    );
  });
  tearDown(() async {
    await cubit.close();
    repo.dispose();
  });

  Future<List<String>> names() async =>
      (await repo.watchCollections().first).map((c) => c.name).toList();

  test('create adds a collection (non-unique names allowed)', () async {
    expect(await cubit.create('Food'), isTrue); // duplicate of the seeded Food
    expect((await names()).where((n) => n == 'Food').length, 2);
  });

  test('rename changes the name', () async {
    expect(await cubit.rename('col_trips', 'Adventures'), isTrue);
    expect(await names(), contains('Adventures'));
  });

  test(
    'delete removes the collection but keeps its posts saved (SC-006)',
    () async {
      final savedBefore = (await repo.allSaved()).valueOrNull!.items.length;

      expect(await cubit.delete('col_food'), isTrue);

      expect(await names(), isNot(contains('Food')));
      expect((await repo.allSaved()).valueOrNull!.items.length, savedBefore);
    },
  );

  test('set-cover updates the collection cover', () async {
    final item = (await repo.collectionItems(
      'col_food',
    )).valueOrNull!.items.first;
    expect(await cubit.setCover('col_food', item.id), isTrue);
  });

  test('a failed mutation returns false', () async {
    repo.failNextMutation = true;
    expect(await cubit.create('X'), isFalse);
  });
}
