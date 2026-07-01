import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/feed/presentation/widgets/feed_status_views.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../helpers/pump_app.dart';

Widget _host(FeedCubit feed) => MultiBlocProvider(
  providers: [
    BlocProvider<FeedCubit>.value(value: feed),
    BlocProvider<StoriesRailCubit>(create: (_) => StubStoriesRailCubit()),
  ],
  child: const HomePage(),
);

Post _post(String id) => Post(
  id: id,
  author: const UserSummary(id: 'u1', username: 'maya', isVerified: true),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 128,
  saveCount: 4,
  commentCount: 2,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption: 'golden hour',
);

Future<void> _pumpHome(WidgetTester tester, FeedState state) async {
  await pumpApp(
    tester,
    _host(StubFeedCubit(state)),
    surfaceSize: const Size(390, 844),
  );
  await tester.pump();
}

void main() {
  setUp(() {
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });
  tearDown(getIt.reset);

  testWidgets('renders posts from the feed (FR-001/FR-008)', (tester) async {
    await _pumpHome(
      tester,
      FeedState.loaded([_post('p1'), _post('p2')], hasMore: false),
    );

    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('shows the empty state when there are no posts (FR-005)', (
    tester,
  ) async {
    await _pumpHome(tester, const FeedState.loaded([], hasMore: false));

    expect(find.byType(FeedEmptyView), findsOneWidget);
  });

  testWidgets(
    'shows the error state with retry when first load fails (FR-005)',
    (tester) async {
      await _pumpHome(tester, const FeedState.error(AppFailure.offline()));

      expect(find.byType(FeedErrorView), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget); // retry
    },
  );
}
