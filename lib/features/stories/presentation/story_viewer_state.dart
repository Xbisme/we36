import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/stories/story.dart';

part 'story_viewer_state.freezed.dart';

/// Story viewer playback state (US5). Navigation only — the visual per-segment
/// progress animation is owned by the page's controller (which respects
/// [paused] and Reduce-Motion). [closed] signals the page to pop.
@freezed
abstract class StoryViewerState with _$StoryViewerState {
  const factory StoryViewerState({
    required List<StoryReel> reels,
    required int reelIndex,
    required int segmentIndex,
    @Default(false) bool paused,
    @Default(false) bool closed,
    @Default(false) bool unavailable,
  }) = _StoryViewerState;

  const StoryViewerState._();

  factory StoryViewerState.initial() =>
      const StoryViewerState(reels: [], reelIndex: 0, segmentIndex: 0);

  StoryReel? get currentReel =>
      (reelIndex >= 0 && reelIndex < reels.length) ? reels[reelIndex] : null;

  StorySegment? get currentSegment {
    final r = currentReel;
    if (r == null || segmentIndex < 0 || segmentIndex >= r.segments.length) {
      return null;
    }
    return r.segments[segmentIndex];
  }
}
