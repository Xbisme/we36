import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_state.dart';

/// Drives the story pick grid (#005): contextual permission, paged Recents, and
/// **single-select** (a story is one photo). Mirrors the compose `GalleryCubit`
/// but replaces the ordered multi-select with one `selectedId`.
@injectable
class StoryGalleryCubit extends Cubit<StoryGalleryState> {
  StoryGalleryCubit(this._library) : super(const StoryGalleryState.initial());

  final PhotoLibraryService _library;

  /// The backing library — the grid uses it for thumbnails (same instance so
  /// resolved asset ids match).
  PhotoLibraryService get library => _library;

  static const int _pageSize = 60;
  int _page = 0;
  bool _busy = false;

  /// Request permission then load the first page.
  Future<void> loadInitial() async {
    emit(const StoryGalleryState.loading());
    final permission = await _library.ensurePermission();
    final denied = permission.fold(
      (p) => p == PhotoPermission.denied,
      (_) => true,
    );
    if (denied) {
      emit(const StoryGalleryState.error(AppFailure.permissionDenied()));
      return;
    }
    _page = 0;
    final result = await _library.loadAssets(page: 0, pageSize: _pageSize);
    emit(
      result.fold(
        (page) => StoryGalleryState.loaded(
          assets: page.assets,
          hasMore: page.hasMore,
        ),
        StoryGalleryState.error,
      ),
    );
  }

  /// Append the next page (lazy pagination — Constitution II).
  Future<void> loadMore() async {
    final current = state;
    if (_busy || current is! StoryGalleryLoaded || !current.hasMore) return;
    _busy = true;
    emit(
      StoryGalleryState.loadedPaginating(
        assets: current.assets,
        hasMore: current.hasMore,
        selectedId: current.selectedId,
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
          StoryGalleryState.loaded(
            assets: [...current.assets, ...page.assets],
            hasMore: page.hasMore,
            selectedId: current.selectedId,
          ),
        );
      },
      (_) => emit(current),
    );
    _busy = false;
  }

  /// Single-select: choose [assetId], or clear it if it is already selected.
  void select(String assetId) {
    final current = state;
    if (current is! StoryGalleryLoaded) return;
    emit(
      StoryGalleryState.loaded(
        assets: current.assets,
        hasMore: current.hasMore,
        selectedId: current.selectedId == assetId ? null : assetId,
      ),
    );
  }
}
