import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_state.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_state.dart';

/// A [CollectionsCubit] test double seeded with a fixed state and inert commands,
/// so widgets render synchronously with no drift stream / async involved (mirrors
/// `StubFeedCubit`/`StubExploreCubit` — widget tests assert a rendered state, not
/// real drift I/O, which deadlocks inside `testWidgets`' faked-async zone).
class StubCollectionsCubit extends Cubit<CollectionsState>
    implements CollectionsCubit {
  StubCollectionsCubit(super.initialState);

  @override
  Future<void> loadInitial() async {}
  @override
  Future<void> retry() async {}
  @override
  Future<void> refresh() async {}
}

/// A deterministic seed: the "All saved" default + a populated + an empty
/// collection.
List<SavedCollection> stubCollections() => [
  SavedCollection(
    id: kAllSavedCollectionId,
    name: 'All saved',
    itemCount: 6,
    isDefault: true,
    coverRefs: const ['https://cdn/1.webp', 'https://cdn/2.webp'],
    updatedAt: DateTime.utc(2026),
  ),
  SavedCollection(
    id: 'col_food',
    name: 'Food',
    itemCount: 3,
    coverRefs: const ['https://cdn/3.webp'],
    updatedAt: DateTime.utc(2026),
  ),
  SavedCollection(
    id: 'col_trips',
    name: 'Trips',
    itemCount: 0,
    updatedAt: DateTime.utc(2026),
  ),
];

/// A [SaveToCollectionCubit] test double seeded with a fixed state + inert
/// commands (widget tests assert a rendered state, not real async).
class StubSaveToCollectionCubit extends Cubit<SaveToCollectionState>
    implements SaveToCollectionCubit {
  StubSaveToCollectionCubit(super.initialState);

  @override
  Future<void> load(String postId) async {}
  @override
  Future<bool> toggle(
    String collectionId, {
    required bool currentlyContains,
  }) async => true;
  @override
  Future<bool> createAndFile(String name) async => true;
}

/// A membership seed: the post is in "Food" but not "Trips".
PostCollectionsMembership stubMembership() => PostCollectionsMembership(
  postId: 'p1',
  isSaved: true,
  collections: [
    CollectionPickerRow(collection: stubCollections()[1], contains: true),
    CollectionPickerRow(collection: stubCollections()[2], contains: false),
  ],
);

/// A [CollectionDetailCubit] test double seeded with a fixed state + inert
/// commands.
class StubCollectionDetailCubit extends Cubit<CollectionDetailState>
    implements CollectionDetailCubit {
  StubCollectionDetailCubit(super.initialState);

  @override
  Future<void> load(String collectionId) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<void> retry() async {}
  @override
  Future<bool> removeFromCollection(String postId) async => true;
  @override
  Future<bool> fullUnsave(String postId) async => true;
}
