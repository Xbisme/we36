import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/features/collections/domain/usecases/collection_items_usecases.dart';
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_state.dart';

/// Drives one collection's item grid (#011 US3): cursor pagination, remove an
/// item from the collection (stays saved elsewhere), and full unsave (cascades
/// everywhere). Removal updates the grid optimistically.
@injectable
class CollectionDetailCubit extends Cubit<CollectionDetailState> {
  CollectionDetailCubit(this._load, this._unfile, this._unsave)
    : super(const CollectionDetailState.initial());

  final LoadCollectionItems _load;
  final UnfileFromCollection _unfile;
  final FullUnsave _unsave;

  String? _id;
  String? _cursor;
  bool _hasMore = true;
  bool _busy = false;

  Future<void> load(String collectionId) async {
    _id = collectionId;
    _cursor = null;
    _hasMore = true;
    emit(const CollectionDetailState.loading());
    final res = await _load(collectionId);
    res.fold(
      (page) {
        _cursor = page.nextCursor;
        _hasMore = page.hasMore;
        emit(
          CollectionDetailState.loaded(items: page.items, hasMore: _hasMore),
        );
      },
      (f) => emit(CollectionDetailState.error(f)),
    );
  }

  Future<void> loadMore() async {
    if (_busy || !_hasMore || _cursor == null || _id == null) return;
    final s = state;
    if (s is! CollectionDetailLoaded) return;
    _busy = true;
    final res = await _load(_id!, cursor: _cursor);
    final page = res.valueOrNull;
    if (page != null) {
      _cursor = page.nextCursor;
      _hasMore = page.hasMore;
      emit(s.copyWith(items: [...s.items, ...page.items], hasMore: _hasMore));
    }
    _busy = false;
  }

  /// Remove [postId] from this collection (stays saved in "All saved").
  Future<bool> removeFromCollection(String postId) async {
    if (_id == null) return false;
    final res = await _unfile(_id!, postId);
    if (res.isOk) _removeItem(postId);
    return res.isOk;
  }

  /// Fully unsave [postId] (cascades from every collection + "All saved").
  Future<bool> fullUnsave(String postId) async {
    final res = await _unsave(postId);
    if (res.isOk) _removeItem(postId);
    return res.isOk;
  }

  void _removeItem(String postId) {
    final s = state;
    if (s is! CollectionDetailLoaded) return;
    emit(s.copyWith(items: s.items.where((i) => i.id != postId).toList()));
  }

  Future<void> retry() => load(_id ?? '');
}
