import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/photo_library_service.dart';

part 'gallery_state.freezed.dart';

/// 4-state for the pick grid. `selectedIds` is ordered (carousel order).
@freezed
sealed class GalleryState with _$GalleryState {
  const GalleryState._();

  const factory GalleryState.initial() = GalleryInitial;

  const factory GalleryState.loading() = GalleryLoading;

  const factory GalleryState.loaded({
    required List<AssetRef> assets,
    required bool hasMore,
    @Default(<String>[]) List<String> selectedIds,
  }) = GalleryLoaded;

  /// Next page in flight — retains assets + selection (Constitution III).
  const factory GalleryState.loadedPaginating({
    required List<AssetRef> assets,
    required bool hasMore,
    @Default(<String>[]) List<String> selectedIds,
  }) = GalleryLoadedPaginating;

  const factory GalleryState.error(AppFailure failure) = GalleryError;

  List<AssetRef> get assets => switch (this) {
    GalleryLoaded(:final assets) => assets,
    GalleryLoadedPaginating(:final assets) => assets,
    _ => const [],
  };

  List<String> get selectedIds => switch (this) {
    GalleryLoaded(:final selectedIds) => selectedIds,
    GalleryLoadedPaginating(:final selectedIds) => selectedIds,
    _ => const [],
  };

  bool get hasMore => switch (this) {
    GalleryLoaded(:final hasMore) => hasMore,
    GalleryLoadedPaginating(:final hasMore) => hasMore,
    _ => false,
  };
}
