import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';

/// The stories seam (#004). **No backend stories contract exists yet** — the
/// fake (`env:['fake']`, runs) synthesizes deterministic reels; a real seam
/// (`env:['real']`) is registered for graph completeness and awaits a future
/// backend stories spec. Only seen-state is persisted (drift); reels are
/// re-synthesized each launch.
abstract interface class StoriesRepository {
  /// Story reels for followed accounts + the current user's own reel.
  Future<Result<List<StoryReel>>> loadReels();

  /// Reactive set of seen segment ids (drift) — drives the rail ring state.
  Stream<Set<String>> watchSeen();

  /// Persist that a segment was viewed (survives relaunch, FR-027).
  Future<Result<void>> markSegmentSeen(String segmentId, String authorId);

  /// Optimistically like the current story segment (in-memory this spec).
  Future<Result<void>> likeSegment(String segmentId, {required bool like});
}
