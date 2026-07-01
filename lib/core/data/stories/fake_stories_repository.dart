import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/story_seen_dao.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/stories_repository.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';

/// Default #004 [StoriesRepository]: deterministic in-memory reels for followed
/// accounts + the current user's own "Your story" reel (Constitution VIII/XII).
/// Seen-state is persisted via [StorySeenDao] so rings survive relaunch;
/// segment likes are held in memory (no backend stories contract yet).
///
/// #005: own published stories are merged in from [OwnStoryStore] (the write
/// path from the compose flow), so a just-published story appears at the head of
/// the "Your story" reel with no manual refresh (FR-011/FR-012).
@LazySingleton(as: StoriesRepository, env: ['fake'])
class FakeStoriesRepository implements StoriesRepository {
  FakeStoriesRepository(this._db, this._ownStories) {
    _reels = _synthesize();
  }

  final AppDatabase _db;
  final OwnStoryStore _ownStories;
  StorySeenDao get _dao => _db.storySeenDao;

  final Set<String> _liked = {};
  late final List<StoryReel> _reels;

  List<StoryReel> _synthesize() {
    final base = DateTime.utc(2026, 7, 1, 12);
    // (username, isYou, segmentCount)
    const specs = <(String, bool, int)>[
      ('you', true, 1),
      ('maya', false, 2),
      ('leo', false, 1),
      ('ava', false, 3),
      ('noah', false, 1),
    ];
    final reels = <StoryReel>[];
    for (final (username, isYou, count) in specs) {
      final authorId = 'user-$username';
      final segments = List<StorySegment>.generate(
        count,
        (i) => StorySegment(
          id: '$authorId-seg-$i',
          authorId: authorId,
          imageUrl: 'https://picsum.photos/seed/$authorId-$i/720/1280',
          durationMs: 5000,
          position: i,
          createdAt: base.subtract(Duration(hours: reels.length, minutes: i)),
        ),
      );
      reels.add(
        StoryReel(
          authorId: authorId,
          username: username,
          segments: segments,
          hasUnseen: true,
          latestAt: segments.first.createdAt,
          isYou: isYou,
        ),
      );
    }
    return reels;
  }

  @override
  Future<Result<List<StoryReel>>> loadReels() async {
    final seen = await _dao.getSeen();
    // Own published segments (newest-first) → chronological to append as the
    // most recent segments of the "Your story" reel (#005, FR-011/FR-012).
    final ownChrono = _ownStories.activeSegments().reversed.toList();
    final reels = _reels.map((r) {
      final merged = <StorySegment>[
        for (final s in r.segments)
          s.copyWith(viewerHasLiked: _liked.contains(s.id)),
        if (r.isYou) ...ownChrono,
      ];
      // Re-sequence positions so the viewer's progress segments stay in order.
      final sequenced = [
        for (var i = 0; i < merged.length; i++) merged[i].copyWith(position: i),
      ];
      return r.copyWith(
        segments: sequenced,
        hasUnseen: sequenced.any((s) => !seen.contains(s.id)),
        // Only the own reel's recency changes here; keep #004 ordering for others.
        latestAt: r.isYou && ownChrono.isNotEmpty
            ? ownChrono.last.createdAt
            : r.latestAt,
      );
    }).toList();
    return Result<List<StoryReel>>.ok(reels);
  }

  @override
  Stream<Set<String>> watchSeen() => _dao.watchSeen();

  @override
  Future<Result<void>> markSegmentSeen(
    String segmentId,
    String authorId,
  ) async {
    await _dao.markSeen(segmentId, authorId);
    return const Result<void>.ok(null);
  }

  @override
  Future<Result<void>> likeSegment(
    String segmentId, {
    required bool like,
  }) async {
    if (like) {
      _liked.add(segmentId);
    } else {
      _liked.remove(segmentId);
    }
    return const Result<void>.ok(null);
  }
}
