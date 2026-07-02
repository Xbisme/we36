import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/reels/domain/reel_draft.dart';

part 'reel_compose_state.freezed.dart';

/// Create-reel flow state (Constitution III 4-state + extended variants).
/// `loaded` carries the pickable videos and the current draft (null until a
/// video is picked); `loadedUploading` carries the in-flight publish fraction.
@freezed
sealed class ReelComposeState with _$ReelComposeState {
  const ReelComposeState._();

  const factory ReelComposeState.initial() = ReelComposeInitial;

  const factory ReelComposeState.loading() = ReelComposeLoading;

  const factory ReelComposeState.loaded({
    required List<AssetRef> videos,
    ReelDraft? draft,
  }) = ReelComposeLoaded;

  const factory ReelComposeState.loadedUploading({
    required ReelDraft draft,
    required double fraction,
  }) = ReelComposeLoadedUploading;

  const factory ReelComposeState.error({
    required AppFailure failure,
    ReelDraft? draft,
  }) = ReelComposeError;

  const factory ReelComposeState.published(Reel reel) = ReelComposePublished;

  ReelDraft? get draft => switch (this) {
    ReelComposeLoaded(:final draft) => draft,
    ReelComposeLoadedUploading(:final draft) => draft,
    ReelComposeError(:final draft) => draft,
    _ => null,
  };

  List<AssetRef> get videos => switch (this) {
    ReelComposeLoaded(:final videos) => videos,
    _ => const [],
  };
}
