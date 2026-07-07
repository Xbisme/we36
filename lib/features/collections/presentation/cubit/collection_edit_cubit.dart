import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collection_edit_state.dart';

/// Drives create/rename/delete/set-cover of a collection (#011 US4). Optimistic
/// via the reactive collections cache — the grid repaints automatically. Each
/// method returns whether the mutation succeeded so the UI can Toast on failure.
/// Delete never unsaves the collection's posts (SC-006).
@injectable
class CollectionEditCubit extends Cubit<CollectionEditState> {
  CollectionEditCubit(this._create, this._rename, this._delete, this._setCover)
    : super(const CollectionEditState.idle());

  final CreateCollection _create;
  final RenameCollection _rename;
  final DeleteCollection _delete;
  final SetCollectionCover _setCover;

  Future<bool> create(String name) async {
    emit(const CollectionEditState.working());
    final res = await _create(name);
    emit(const CollectionEditState.idle());
    return res.isOk;
  }

  Future<bool> rename(String id, String name) async {
    emit(const CollectionEditState.working());
    final res = await _rename(id, name);
    emit(const CollectionEditState.idle());
    return res.isOk;
  }

  Future<bool> setCover(String id, String coverItemId) async {
    emit(const CollectionEditState.working());
    final res = await _setCover(id, coverItemId);
    emit(const CollectionEditState.idle());
    return res.isOk;
  }

  Future<bool> delete(String id) async {
    emit(const CollectionEditState.working());
    final res = await _delete(id);
    emit(const CollectionEditState.idle());
    return res.isOk;
  }
}
