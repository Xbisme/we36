import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../helpers/pump_app.dart';

/// T063 / SC-002 — a long feed stays lazy: the `ListView.builder` only realizes
/// the visible window (never all 200 posts), scrolling to the end never throws,
/// and media decode stays bounded (no raw `NetworkImage`, fakes carry no URL).
Post _post(int i) => Post(
  id: 'p$i',
  author: UserSummary(id: 'u$i', username: 'user$i', isVerified: i.isEven),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: i,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption: 'synthesized post $i',
);

void main() {
  setUp(() {
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });
  tearDown(getIt.reset);

  testWidgets('200-post feed stays lazy and scrolls to the end without crash', (
    tester,
  ) async {
    final posts = List.generate(200, _post);
    final host = MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>(
          create: (_) => StubFeedCubit(FeedState.loaded(posts, hasMore: false)),
        ),
        BlocProvider<StoriesRailCubit>(create: (_) => StubStoriesRailCubit()),
      ],
      child: const HomePage(),
    );

    await pumpApp(tester, host, surfaceSize: const Size(390, 844));
    await tester.pump();

    // Lazy: only a small window is realized, not all 200.
    expect(find.byType(PostCard), findsWidgets);
    expect(
      tester.widgetList(find.byType(PostCard)).length,
      lessThan(posts.length),
      reason: 'ListView.builder must not build every post at once',
    );

    // Scroll fully to the end in steps — must never throw.
    final list = find.byType(Scrollable).first;
    for (var i = 0; i < 60; i++) {
      await tester.drag(list, const Offset(0, -4000));
      await tester.pump();
    }
    expect(tester.takeException(), isNull);

    // No raw network image providers anywhere (bounded decode invariant).
    expect(
      find.byWidgetPredicate((w) => w is Image && w.image is NetworkImage),
      findsNothing,
    );
  });
}
