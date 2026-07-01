import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';

part 'compose_state.freezed.dart';

/// 4-state for the compose flow (pick→edit→caption→publish). Holds the working
/// [ComposeDraft] and the active carousel item being edited.
@freezed
sealed class ComposeState with _$ComposeState {
  const ComposeState._();

  const factory ComposeState.initial() = ComposeInitial;

  /// Restoring a persisted draft on flow entry.
  const factory ComposeState.loading() = ComposeLoading;

  /// Editing / captioning.
  const factory ComposeState.loaded({
    required ComposeDraft draft,
    @Default(0) int activeItemIndex,
  }) = ComposeLoaded;

  /// Publish in flight (cancelable) — retains the draft + overall progress.
  const factory ComposeState.loadedUploading({
    required ComposeDraft draft,
    @Default(0.0) double progress,
  }) = ComposeLoadedUploading;

  /// Publish failed — retains the draft for retry (FR-019).
  const factory ComposeState.error({
    required AppFailure failure,
    required ComposeDraft draft,
  }) = ComposeError;

  /// Terminal success — the created post; the flow pops + toasts on this.
  const factory ComposeState.published(Post post) = ComposePublished;

  ComposeDraft? get draftOrNull => switch (this) {
    ComposeLoaded(:final draft) => draft,
    ComposeLoadedUploading(:final draft) => draft,
    ComposeError(:final draft) => draft,
    _ => null,
  };
}
