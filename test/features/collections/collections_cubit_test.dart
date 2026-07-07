import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/fake_collections_repository.dart';
import 'package:we36/features/collections/domain/usecases/collections_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';

/// Logic tests for [CollectionsCubit] over the in-memory fake repo (real async;
/// no drift I/O inside `testWidgets` — the #009 gate learning).
void main() {
  late FakeCollectionsRepository repo;
  late CollectionsCubit cubit;

  setUp(() {
    repo = FakeCollectionsRepository();
    cubit = CollectionsCubit(WatchCollections(repo), LoadCollections(repo));
  });

  tearDown(() async {
    await cubit.close();
    repo.dispose();
  });

  test(
    'loads the collections list cache-first ("All saved" first, not offline)',
    () async {
      await cubit.loadInitial();
      await Future<void>.delayed(Duration.zero);

      final s = cubit.state;
      expect(s, isA<CollectionsLoaded>());
      final loaded = s as CollectionsLoaded;
      expect(loaded.collections.first.isDefault, isTrue);
      expect(loaded.namedCollections.map((c) => c.name), contains('Food'));
      expect(loaded.isOffline, isFalse);
    },
  );

  test(
    'a failed background reconcile keeps the cache with an offline hint',
    () async {
      repo.failNextQuery = true; // refreshCollections() fails

      await cubit.loadInitial();
      await Future<void>.delayed(Duration.zero);

      final s = cubit.state as CollectionsLoaded;
      expect(s.collections, isNotEmpty);
      expect(s.isOffline, isTrue);
    },
  );

  test(
    'an optimistic create elsewhere repaints through the reactive cache',
    () async {
      await cubit.loadInitial();
      await Future<void>.delayed(Duration.zero);
      final before = (cubit.state as CollectionsLoaded).namedCollections.length;

      await repo.create('New Board');
      await Future<void>.delayed(Duration.zero);

      final after = (cubit.state as CollectionsLoaded).namedCollections.length;
      expect(after, before + 1);
    },
  );
}
