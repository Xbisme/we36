import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/features/collections/domain/usecases/collections_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';

/// Drives the Saved-tab collections grid (#011 US1). Reads the one canonical
/// collections list reactively from the cache (renders offline-from-cache,
/// FR-012) and reconciles with the server in the background. An optimistic
/// create/rename/delete/file elsewhere repaints here through the same cache.
@injectable
class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit(this._watch, this._load)
    : super(const CollectionsState.initial());

  final WatchCollections _watch;
  final LoadCollections _load;

  StreamSubscription<List<SavedCollection>>? _sub;
  bool _offline = false;
  bool _hasData = false;

  Future<void> loadInitial() async {
    emit(const CollectionsState.loading());
    _hasData = false;
    _offline = false;
    _sub ??= _watch().listen(_onData);
    final res = await _load();
    _offline = res.isErr;
    final s = state;
    if (s is CollectionsLoaded) {
      // Cache already rendered → keep it, flag offline if the reconcile failed.
      emit(s.copyWith(isOffline: _offline));
    } else if (res.isErr && !_hasData) {
      // Nothing cached and the reconcile failed → surface the error.
      emit(CollectionsState.error(res.failureOrNull!));
    }
  }

  void _onData(List<SavedCollection> collections) {
    _hasData = true;
    emit(
      CollectionsState.loaded(collections: collections, isOffline: _offline),
    );
  }

  Future<void> retry() => loadInitial();

  /// Re-reconcile with the server without a loading flash (e.g. when the Saved
  /// surface becomes visible again after a save/unsave elsewhere). The reactive
  /// cache repaints the grid; only the offline hint is updated here.
  Future<void> refresh() async {
    if (state is! CollectionsLoaded) {
      await loadInitial();
      return;
    }
    final res = await _load();
    _offline = res.isErr;
    final s = state;
    if (s is CollectionsLoaded) emit(s.copyWith(isOffline: _offline));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
