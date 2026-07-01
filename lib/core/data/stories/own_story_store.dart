import 'dart:async';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';

/// Story time-to-live — a segment older than this is expired (FR-013).
const Duration kStoryTtl = Duration(hours: 24);

/// URI scheme for an own, offline-published story image whose bytes live in
/// [OwnStoryStore] (no disk / no new dependency — U1). The story image resolver
/// maps `memory://<segmentId>` → a `MemoryImage` from [OwnStoryStore.bytesFor].
const String kOwnStoryScheme = 'memory';

/// Build the in-memory image ref for an own published [segmentId].
String ownStoryImageUrl(String segmentId) => '$kOwnStoryScheme://$segmentId';

/// The one canonical representation of the current user's own **published**
/// story segments for this session (#005, Constitution IX). It bridges the
/// write path ([FakeCreateStoryRepository]) and the #004 read path
/// ([FakeStoriesRepository]) without a repo→repo dependency and without a drift
/// schema change (research R3). Session-scoped: not persisted across app kill
/// (acceptable with no backend; revisit when a backend stories contract lands).
///
/// [clear] is invoked on logout so nothing leaks to the next account
/// (Constitution I). Expiry is a read-time filter using an injectable [_clock]
/// so tests can advance time (research R4).
@lazySingleton
class OwnStoryStore {
  OwnStoryStore({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  /// Constructor injectable uses (it can't resolve the inline function type of
  /// the `clock` test seam above, so we expose a parameterless factory).
  @factoryMethod
  factory OwnStoryStore.create() => OwnStoryStore();

  final DateTime Function() _clock;
  final List<StorySegment> _segments = [];
  final Map<String, Uint8List> _bytes = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  /// Fires after [add]/[clear] so the rail can re-read and repaint (FR-011).
  Stream<void> get changes => _changes.stream;

  /// Append a freshly published segment (with its flattened image [bytes], kept
  /// in memory so the viewer can render the offline story — U1) and notify.
  void add(StorySegment segment, {Uint8List? bytes}) {
    _segments.add(segment);
    if (bytes != null) _bytes[segment.id] = bytes;
    if (!_changes.isClosed) _changes.add(null);
  }

  /// The in-memory image bytes for an own published [segmentId] (U1 resolver).
  Uint8List? bytesFor(String segmentId) => _bytes[segmentId];

  /// Own segments still active (created within the last 24h), newest first.
  List<StorySegment> activeSegments() {
    final threshold = _clock().toUtc().subtract(kStoryTtl);
    return _segments
        .where((s) => s.createdAt.toUtc().isAfter(threshold))
        .toList()
        .reversed
        .toList();
  }

  /// True when there is at least one active own segment (drives the ring).
  bool get hasActive => activeSegments().isNotEmpty;

  /// Wipe on logout (privacy — Constitution I/IX).
  void clear() {
    if (_segments.isEmpty && _bytes.isEmpty) return;
    _segments.clear();
    _bytes.clear();
    if (!_changes.isClosed) _changes.add(null);
  }

  @disposeMethod
  void dispose() => _changes.close();
}
