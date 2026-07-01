import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/features/stories/domain/models/story_sticker_overlay.dart';
import 'package:we36/features/stories/domain/models/story_text_overlay.dart';

part 'story_compose_draft.freezed.dart';

/// The in-composer working state of a story being created (#005). Transient —
/// **NOT persisted** (no drift row, unlike Create Post); abandoning the composer
/// discards it after a confirm (FR-015). Overlays are baked at publish (R1).
@freezed
abstract class StoryComposeDraft with _$StoryComposeDraft {
  const factory StoryComposeDraft({
    required String assetId,
    required String idempotencyKey,
    @Default(<StoryTextOverlay>[]) List<StoryTextOverlay> textOverlays,
    @Default(<StoryStickerOverlay>[]) List<StoryStickerOverlay> stickerOverlays,
    @Default(StoryAudience.yourStory) StoryAudience audience,
  }) = _StoryComposeDraft;

  const StoryComposeDraft._();

  /// True once overlays exist — drives the discard-confirm on back-out (FR-015).
  bool get hasOverlays =>
      textOverlays.isNotEmpty || stickerOverlays.isNotEmpty;
}
