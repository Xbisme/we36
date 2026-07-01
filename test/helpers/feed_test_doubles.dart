import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

/// A [FeedCubit] test double seeded with a fixed state and inert commands, so
/// widgets render synchronously with no drift stream / async involved.
class StubFeedCubit extends Cubit<FeedState> implements FeedCubit {
  StubFeedCubit(super.initialState);

  @override
  Future<void> loadInitial() async {}
  @override
  Future<void> retry() async {}
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<Result<EngagementState>> toggleLike(Post post) =>
      throw UnimplementedError();
  @override
  Future<Result<EngagementState>> toggleSave(Post post) =>
      throw UnimplementedError();
}

/// A [StoriesRailCubit] test double seeded with a fixed reel list.
class StubStoriesRailCubit extends AppCubit<List<StoryReel>>
    implements StoriesRailCubit {
  StubStoriesRailCubit([List<StoryReel> reels = const []]) {
    emitLoaded(reels);
  }

  @override
  Future<void> load() async {}
}
