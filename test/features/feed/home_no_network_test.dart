import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/stories_rail.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../helpers/pump_app.dart';

/// FR-026 / SC-007 — Home renders its stories rail and post cards entirely from
/// fakes (no `http` media URLs), so the widget tree contains zero [NetworkImage]
/// providers: the app builds and runs with zero network.
Post _post(String id) => Post(
  id: id,
  author: UserSummary(id: 'u-$id', username: 'user_$id', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 12,
  saveCount: 1,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption: 'no-network post',
);

StoryReel _reel(String id, {required bool you}) => StoryReel(
  authorId: id,
  username: id,
  segments: const [],
  hasUnseen: true,
  latestAt: DateTime.utc(2026, 7),
  isYou: you,
);

Widget _host() => MultiBlocProvider(
  providers: [
    BlocProvider<FeedCubit>(
      create: (_) => StubFeedCubit(
        FeedState.loaded([_post('a'), _post('b')], hasMore: false),
      ),
    ),
    BlocProvider<StoriesRailCubit>(
      create: (_) => StubStoriesRailCubit([
        _reel('you', you: true),
        _reel('maya', you: false),
      ]),
    ),
  ],
  child: const HomePage(),
);

void main() {
  setUp(() {
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });
  tearDown(getIt.reset);

  testWidgets(
    'Home renders stories + post cards from fakes with zero network '
    '(FR-026/SC-007)',
    (tester) async {
      await pumpApp(tester, _host(), surfaceSize: const Size(390, 900));
      await tester.pump();

      expect(find.byType(StoriesRail), findsOneWidget);
      expect(find.byType(PostCard), findsWidgets);

      // No network image providers anywhere in the tree.
      final networkImages = find.byWidgetPredicate(
        (w) => w is Image && w.image is NetworkImage,
      );
      expect(networkImages, findsNothing);
    },
  );
}
