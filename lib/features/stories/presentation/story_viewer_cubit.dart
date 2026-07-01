import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/stories/domain/usecases/story_usecases.dart';
import 'package:we36/features/stories/presentation/story_viewer_state.dart';

/// Story viewer playback (US5). Owns navigation across reels/segments, marks
/// each shown segment seen (persisted, FR-027), and likes optimistically. The
/// per-segment progress animation + auto-advance timing live in the page, which
/// calls [next] on completion and toggles [pause]/[resume] on press-hold.
@injectable
class StoryViewerCubit extends Cubit<StoryViewerState> {
  StoryViewerCubit(this._markSeen, this._likeSegment)
    : super(StoryViewerState.initial());

  final MarkSegmentSeen _markSeen;
  final LikeStorySegment _likeSegment;

  /// Open the viewer on [startReelIndex]. An empty/invalid target is surfaced as
  /// unavailable (FR-028).
  void open(List<StoryReel> reels, int startReelIndex) {
    if (reels.isEmpty ||
        startReelIndex < 0 ||
        startReelIndex >= reels.length ||
        reels[startReelIndex].segments.isEmpty) {
      emit(
        StoryViewerState.initial().copyWith(unavailable: true, closed: true),
      );
      return;
    }
    emit(
      StoryViewerState(
        reels: reels,
        reelIndex: startReelIndex,
        segmentIndex: 0,
      ),
    );
    _markCurrentSeen();
  }

  /// Advance to the next segment, then the next reel, else close.
  void next() {
    final reel = state.currentReel;
    if (reel == null) return;
    if (state.segmentIndex < reel.segments.length - 1) {
      emit(state.copyWith(segmentIndex: state.segmentIndex + 1, paused: false));
      _markCurrentSeen();
    } else if (state.reelIndex < state.reels.length - 1) {
      emit(
        state.copyWith(
          reelIndex: state.reelIndex + 1,
          segmentIndex: 0,
          paused: false,
        ),
      );
      _markCurrentSeen();
    } else {
      emit(state.copyWith(closed: true));
    }
  }

  /// Go back a segment, then to the previous reel's last segment.
  void previous() {
    if (state.segmentIndex > 0) {
      emit(state.copyWith(segmentIndex: state.segmentIndex - 1, paused: false));
    } else if (state.reelIndex > 0) {
      final prev = state.reels[state.reelIndex - 1];
      emit(
        state.copyWith(
          reelIndex: state.reelIndex - 1,
          segmentIndex: prev.segments.length - 1,
          paused: false,
        ),
      );
    }
  }

  void pause() => emit(state.copyWith(paused: true));
  void resume() => emit(state.copyWith(paused: false));

  /// Optimistically like/unlike the current segment (FR-025).
  Future<Result<void>> likeCurrent() async {
    final seg = state.currentSegment;
    if (seg == null) return const Result<void>.ok(null);
    final like = !seg.viewerHasLiked;
    _setSegmentLiked(liked: like);
    final result = await _likeSegment(seg.id, like: like);
    if (result.isErr) _setSegmentLiked(liked: !like); // rollback
    return result;
  }

  void _setSegmentLiked({required bool liked}) {
    final reel = state.currentReel;
    if (reel == null) return;
    final segments = [...reel.segments];
    segments[state.segmentIndex] = segments[state.segmentIndex].copyWith(
      viewerHasLiked: liked,
    );
    final reels = [...state.reels];
    reels[state.reelIndex] = reel.copyWith(segments: segments);
    emit(state.copyWith(reels: reels));
  }

  void _markCurrentSeen() {
    final seg = state.currentSegment;
    if (seg != null) unawaited(_markSeen(seg.id, seg.authorId));
  }
}
