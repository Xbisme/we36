import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';

part 'story_compose_state.freezed.dart';

/// 4-state for the story compose flow (pick → decorate → publish). Holds the
/// working [StoryComposeDraft]; extended variants cover the in-flight upload and
/// terminal success (the page pops + toasts on `published`).
@freezed
sealed class StoryComposeState with _$StoryComposeState {
  const StoryComposeState._();

  const factory StoryComposeState.initial() = StoryComposeInitial;

  /// Editing the picked photo (overlays + audience); share enabled.
  const factory StoryComposeState.loaded({
    required StoryComposeDraft draft,
  }) = StoryComposeLoaded;

  /// Publish in flight (cancelable) — retains the draft + 0..1 progress.
  const factory StoryComposeState.loadedUploading({
    required StoryComposeDraft draft,
    @Default(0.0) double progress,
  }) = StoryComposeLoadedUploading;

  /// Publish failed — retains the draft for retry (FR-009/FR-014).
  const factory StoryComposeState.error({
    required AppFailure failure,
    required StoryComposeDraft draft,
  }) = StoryComposeError;

  /// Terminal success — the published segment; the flow pops + toasts on this.
  const factory StoryComposeState.published(StorySegment segment) =
      StoryComposePublished;

  StoryComposeDraft? get draftOrNull => switch (this) {
    StoryComposeLoaded(:final draft) => draft,
    StoryComposeLoadedUploading(:final draft) => draft,
    StoryComposeError(:final draft) => draft,
    _ => null,
  };
}
