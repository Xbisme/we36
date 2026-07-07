import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/explore_state.dart';

/// An [ExploreCubit] test double seeded with a fixed state and inert commands, so
/// widgets render synchronously with no drift stream / async involved. Mirrors the
/// `StubFeedCubit` pattern — widget tests assert on a rendered state, not on real
/// drift I/O (which deadlocks inside `testWidgets`' faked-async zone).
class StubExploreCubit extends Cubit<ExploreState> implements ExploreCubit {
  StubExploreCubit(super.initialState);

  @override
  Future<void> loadInitial() async {}
  @override
  Future<void> retry() async {}
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async {}
}

/// A deterministic mix of photo + reel discovery cells (every 3rd is a reel), used
/// to seed [StubExploreCubit] so the grid renders both tile kinds.
List<ExploreItem> stubExploreItems({int count = 9}) {
  final base = DateTime.utc(2026, 7, 1, 12);
  return List<ExploreItem>.generate(count, (i) {
    final author = UserSummary(
      id: 'user-$i',
      username: 'author$i',
      isVerified: i.isEven,
    );
    final createdAt = base.subtract(Duration(hours: i));
    if (i % 3 == 2) {
      return ExploreItem(
        kind: ExploreItemKind.reel,
        reel: Reel(
          id: 'stub-reel-$i',
          author: author,
          video: const Media(
            id: 'stub-reel-media',
            kind: MediaKind.video,
            status: MediaStatus.ready,
            width: 720,
            height: 1280,
          ),
          hashtags: const [],
          taggedUsers: const [],
          commentsDisabled: false,
          likeCount: 200 + i,
          saveCount: 10 + i,
          commentCount: i % 5,
          viewerHasLiked: false,
          viewerHasSaved: false,
          isVideoReady: true,
          createdAt: createdAt,
        ),
      );
    }
    return ExploreItem(
      kind: ExploreItemKind.post,
      post: Post(
        id: 'stub-post-$i',
        author: author,
        media: const [
          PostMedia(
            position: 0,
            media: Media(
              id: 'stub-post-media',
              kind: MediaKind.image,
              status: MediaStatus.ready,
              width: 1080,
              height: 1350,
            ),
          ),
        ],
        hashtags: const [],
        taggedUsers: const [],
        commentsDisabled: false,
        likeCount: 90 + i,
        saveCount: 4 + i,
        commentCount: i % 4,
        viewerHasLiked: false,
        viewerHasSaved: false,
        createdAt: createdAt,
      ),
    );
  });
}
