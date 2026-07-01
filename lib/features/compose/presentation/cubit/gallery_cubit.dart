import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_state.dart';

/// Drives the pick grid: contextual permission, paged Recents, and ordered
/// (multi-)selection with the carousel cap (FR-004/005/006/007).
@injectable
class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit(this._library) : super(const GalleryState.initial());

  final PhotoLibraryService _library;

  static const int _pageSize = 60;
  int _page = 0;
  bool _busy = false;

  /// Request permission then load the first page.
  Future<void> loadInitial() async {
    emit(const GalleryState.loading());
    final permission = await _library.ensurePermission();
    final denied = permission.fold(
      (p) => p == PhotoPermission.denied,
      (_) => true,
    );
    if (denied) {
      emit(const GalleryState.error(AppFailure.permissionDenied()));
      return;
    }
    _page = 0;
    final result = await _library.loadAssets(page: 0, pageSize: _pageSize);
    emit(
      result.fold(
        (page) => GalleryState.loaded(
          assets: page.assets,
          hasMore: page.hasMore,
        ),
        GalleryState.error,
      ),
    );
  }

  /// Append the next page (lazy pagination — Constitution II).
  Future<void> loadMore() async {
    final current = state;
    if (_busy || current is! GalleryLoaded || !current.hasMore) return;
    _busy = true;
    emit(
      GalleryState.loadedPaginating(
        assets: current.assets,
        hasMore: current.hasMore,
        selectedIds: current.selectedIds,
      ),
    );
    final result = await _library.loadAssets(
      page: _page + 1,
      pageSize: _pageSize,
    );
    result.fold(
      (page) {
        _page += 1;
        emit(
          GalleryState.loaded(
            assets: [...current.assets, ...page.assets],
            hasMore: page.hasMore,
            selectedIds: current.selectedIds,
          ),
        );
      },
      (_) => emit(current),
    );
    _busy = false;
  }

  /// Toggle selection of [assetId], preserving order and enforcing the cap.
  /// Returns false if the add was blocked by the carousel cap (FR-006).
  bool toggleSelect(String assetId) {
    final current = state;
    if (current is! GalleryLoaded) return false;
    final selected = [...current.selectedIds];
    if (selected.contains(assetId)) {
      selected.remove(assetId);
    } else {
      if (selected.length >= kCarouselMaxItems) return false;
      selected.add(assetId);
    }
    emit(
      GalleryState.loaded(
        assets: current.assets,
        hasMore: current.hasMore,
        selectedIds: selected,
      ),
    );
    return true;
  }
}
