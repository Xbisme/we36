import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_state.dart';

/// Drives the Save-to-collection sheet (#011 US2). Loads the post's membership,
/// toggles it into/out of a collection **optimistically** (rollback on failure),
/// and creates a collection inline then files the post into it. Filing an unsaved
/// post also sets the canonical saved flag (reconciled from the reload).
@injectable
class SaveToCollectionCubit extends Cubit<SaveToCollectionState> {
  SaveToCollectionCubit(
    this._loadPicker,
    this._file,
    this._unfile,
    this._create,
  ) : super(const SaveToCollectionState.initial());

  final LoadPicker _loadPicker;
  final FileIntoCollection _file;
  final UnfileFromCollection _unfile;
  final CreateCollection _create;

  String? _postId;

  Future<void> load(String postId) async {
    _postId = postId;
    emit(const SaveToCollectionState.loading());
    final res = await _loadPicker(postId);
    res.fold(
      (m) => emit(SaveToCollectionState.loaded(membership: m)),
      (f) => emit(SaveToCollectionState.error(f)),
    );
  }

  /// Toggle membership for [collectionId] optimistically; returns false (and
  /// rolls back) on failure so the sheet can show a Toast.
  Future<bool> toggle(
    String collectionId, {
    required bool currentlyContains,
  }) async {
    final s = state;
    if (s is! SaveToCollectionLoaded || _postId == null) return false;
    emit(
      s.copyWith(
        membership: _flip(s.membership, collectionId, !currentlyContains),
      ),
    );
    final res = currentlyContains
        ? await _unfile(collectionId, _postId!)
        : await _file(collectionId, _postId!);
    if (res.isErr) {
      final cur = state;
      if (cur is SaveToCollectionLoaded) {
        emit(
          cur.copyWith(
            membership: _flip(cur.membership, collectionId, currentlyContains),
          ),
        );
      }
      return false;
    }
    // Reload so isSaved reconciles (filing an unsaved post saves it).
    final m = await _loadPicker(_postId!);
    final cur = state;
    if (m.isOk && cur is SaveToCollectionLoaded) {
      emit(cur.copyWith(membership: m.valueOrNull!));
    }
    return true;
  }

  /// Create a collection inline and file the post into it; returns false on error.
  Future<bool> createAndFile(String name) async {
    final s = state;
    if (s is! SaveToCollectionLoaded || _postId == null) return false;
    emit(s.copyWith(creating: true));
    final created = await _create(name);
    if (created.isErr) {
      emit(s.copyWith(creating: false));
      return false;
    }
    final filed = await _file(created.valueOrNull!.id, _postId!);
    final m = await _loadPicker(_postId!);
    final cur = state;
    if (m.isOk && cur is SaveToCollectionLoaded) {
      emit(SaveToCollectionState.loaded(membership: m.valueOrNull!));
    } else if (cur is SaveToCollectionLoaded) {
      emit(cur.copyWith(creating: false));
    }
    return filed.isOk;
  }

  PostCollectionsMembership _flip(
    PostCollectionsMembership m,
    String collectionId,
    bool contains,
  ) => m.copyWith(
    collections: [
      for (final r in m.collections)
        if (r.collection.id == collectionId)
          r.copyWith(contains: contains)
        else
          r,
    ],
  );
}
