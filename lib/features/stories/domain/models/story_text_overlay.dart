import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_text_overlay.freezed.dart';

/// Maximum length of a single story text overlay (clarification Q3, FR-004).
const int kStoryTextMaxLength = 100;

/// A short line of text placed on the 9:16 story canvas (#005). Position is
/// normalized (0..1) within the canvas; the overlay is **baked** into the
/// exported image at publish (no editable metadata is stored — R1/FR-005).
@freezed
abstract class StoryTextOverlay with _$StoryTextOverlay {
  const factory StoryTextOverlay({
    required String id,
    required String text,

    /// A key into the small fixed set of token-driven text styles/colors.
    required String styleId,
    @Default(0.5) double dx,
    @Default(0.5) double dy,
  }) = _StoryTextOverlay;
}
