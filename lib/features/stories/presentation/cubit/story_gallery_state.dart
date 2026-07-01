import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/photo_library_service.dart';

part 'story_gallery_state.freezed.dart';

/// 4-state for the story pick grid (#005). Single-select — `selectedId` is the
/// one chosen photo (or null), unlike the compose carousel's ordered list.
@freezed
sealed class StoryGalleryState with _$StoryGalleryState {
  const StoryGalleryState._();

  const factory StoryGalleryState.initial() = StoryGalleryInitial;

  const factory StoryGalleryState.loading() = StoryGalleryLoading;

  const factory StoryGalleryState.loaded({
    required List<AssetRef> assets,
    required bool hasMore,
    String? selectedId,
  }) = StoryGalleryLoaded;

  /// Next page in flight — retains assets + selection (Constitution III).
  const factory StoryGalleryState.loadedPaginating({
    required List<AssetRef> assets,
    required bool hasMore,
    String? selectedId,
  }) = StoryGalleryLoadedPaginating;

  const factory StoryGalleryState.error(AppFailure failure) = StoryGalleryError;

  List<AssetRef> get assets => switch (this) {
    StoryGalleryLoaded(:final assets) => assets,
    StoryGalleryLoadedPaginating(:final assets) => assets,
    _ => const [],
  };

  String? get selectedId => switch (this) {
    StoryGalleryLoaded(:final selectedId) => selectedId,
    StoryGalleryLoadedPaginating(:final selectedId) => selectedId,
    _ => null,
  };

  bool get hasMore => switch (this) {
    StoryGalleryLoaded(:final hasMore) => hasMore,
    StoryGalleryLoadedPaginating(:final hasMore) => hasMore,
    _ => false,
  };
}
