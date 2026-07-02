import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/story_seen_dao.dart';
import 'package:we36/core/data/feed/post.dart' show renditionUrl;
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/stories_repository.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Real stories seam (`env:['real']`, B#006 stories contract). The tray is
/// assembled from the backend (`GET /stories/feed`) for other authors, with the
/// current user's own just-published stories merged in from [OwnStoryStore] (the
/// compose write path) so a fresh story shows at the head with no manual refresh
/// (FR-011/FR-012). Seen-state persists in drift (survives relaunch, FR-027).
@LazySingleton(as: StoriesRepository, env: ['real'])
class StoriesRepositoryImpl implements StoriesRepository {
  StoriesRepositoryImpl(this._db, this._api, this._ownStories);

  /// Photo story segment display duration (clarification Q2).
  static const int _segmentDurationMs = 5000;

  final AppDatabase _db;
  final ApiClient _api;
  final OwnStoryStore _ownStories;
  StorySeenDao get _dao => _db.storySeenDao;

  @override
  Future<Result<List<StoryReel>>> loadReels() async {
    final seen = await _dao.getSeen();

    // Other authors' active stories from the backend tray.
    final tray = await _api.get<List<StoryReel>>(
      ApiEndpoints.storiesFeed,
      decode: (data) => _othersFromTray(data as Map<String, dynamic>, seen),
    );

    // The current user's own reel from the session write path (renders instantly
    // from local bytes, ahead of the backend tray converging).
    final own = _ownReel(seen);

    if (tray.isErr) {
      // A tray fetch failure still surfaces the own story (offline-friendly);
      // only fail hard when there is nothing at all to show.
      return own == null
          ? Result<List<StoryReel>>.err(tray.failureOrNull!)
          : Result<List<StoryReel>>.ok([own]);
    }
    return Result<List<StoryReel>>.ok([?own, ...tray.valueOrNull!]);
  }

  /// Build the "Your story" reel from own published segments (newest-first store
  /// → chronological play order), re-sequencing positions. Null when none active.
  StoryReel? _ownReel(Set<String> seen) {
    final chrono = _ownStories.activeSegments().reversed.toList();
    if (chrono.isEmpty) return null;
    final sequenced = [
      for (var i = 0; i < chrono.length; i++) chrono[i].copyWith(position: i),
    ];
    return StoryReel(
      authorId: sequenced.first.authorId,
      username: 'you',
      segments: sequenced,
      hasUnseen: sequenced.any((s) => !seen.contains(s.id)),
      latestAt: sequenced.last.createdAt,
      isYou: true,
    );
  }

  /// Map the backend tray to reels for every author except self (the own reel is
  /// sourced from [OwnStoryStore]). Segments whose media has no delivery URL yet
  /// (still processing) are skipped rather than rendered blank.
  List<StoryReel> _othersFromTray(Map<String, dynamic> json, Set<String> seen) {
    final items = json['items'];
    if (items is! List) return const [];
    final reels = <StoryReel>[];
    for (final item in items) {
      if (item is! Map || item['isSelf'] == true) continue;
      final author =
          (item['author'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rawStories = item['stories'];
      if (rawStories is! List) continue;

      final segments = <StorySegment>[];
      for (final s in rawStories) {
        if (s is! Map) continue;
        final media = s['media'];
        final variants = media is Map
            ? (media['variants'] as Map?)?.cast<String, dynamic>()
            : null;
        final url = renditionUrl(variants);
        if (url == null) continue; // Still processing / no delivery URL yet.
        segments.add(
          StorySegment(
            id: s['id'] as String,
            authorId: author['id'] as String? ?? '',
            imageUrl: url,
            durationMs: _segmentDurationMs,
            position: segments.length,
            createdAt:
                DateTime.tryParse(s['createdAt'] as String? ?? '')?.toUtc() ??
                DateTime.now().toUtc(),
          ),
        );
      }
      if (segments.isEmpty) continue;

      reels.add(
        StoryReel(
          authorId: author['id'] as String? ?? '',
          username:
              (author['username'] ?? author['displayName'] ?? '') as String,
          segments: segments,
          hasUnseen:
              (item['hasUnseen'] as bool?) ??
              segments.any((s) => !seen.contains(s.id)),
          latestAt: segments.last.createdAt,
        ),
      );
    }
    return reels;
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
  }) async => const Result<void>.err(AppFailure.offline());
}
