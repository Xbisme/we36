import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/stories_repository.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';

/// Story use cases (Constitution III) — thin seams over [StoriesRepository].

@injectable
class LoadStoryReels {
  const LoadStoryReels(this._repo);
  final StoriesRepository _repo;
  Future<Result<List<StoryReel>>> call() => _repo.loadReels();
}

@injectable
class WatchSeenSegments {
  const WatchSeenSegments(this._repo);
  final StoriesRepository _repo;
  Stream<Set<String>> call() => _repo.watchSeen();
}

@injectable
class MarkSegmentSeen {
  const MarkSegmentSeen(this._repo);
  final StoriesRepository _repo;
  Future<Result<void>> call(String segmentId, String authorId) =>
      _repo.markSegmentSeen(segmentId, authorId);
}

@injectable
class LikeStorySegment {
  const LikeStorySegment(this._repo);
  final StoriesRepository _repo;
  Future<Result<void>> call(String segmentId, {required bool like}) =>
      _repo.likeSegment(segmentId, like: like);
}
