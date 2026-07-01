import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/story_seen_dao.dart';
import 'package:we36/core/data/stories/stories_repository.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// **Provisional** real stories seam (`env:['real']`). No backend stories
/// contract exists yet (backend has auth/posts/media/comments only), so
/// `loadReels`/`likeSegment` return safe defaults and only seen-state persists.
/// Registered for DI-graph completeness under the `real` environment; never
/// exercised while the app runs `fake`. Finalize when a backend stories spec
/// lands (documented follow-up).
@LazySingleton(as: StoriesRepository, env: ['real'])
class StoriesRepositoryImpl implements StoriesRepository {
  StoriesRepositoryImpl(this._db);

  final AppDatabase _db;
  StorySeenDao get _dao => _db.storySeenDao;

  @override
  Future<Result<List<StoryReel>>> loadReels() async =>
      const Result<List<StoryReel>>.ok([]);

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
