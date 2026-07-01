import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/app/app.dart';
import 'package:we36/core/data/auth/fake_auth_backend.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/bottom_nav.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/sidebar_rail.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/router/app_router.dart';
import 'package:we36/features/explore/presentation/explore_page.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../support/auth_test_doubles.dart';

Post _post(int i) => Post(
  id: 'p$i',
  author: UserSummary(id: 'u$i', username: 'user$i', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 3,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption: 'shell post $i',
);

Future<void> _pumpAppAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  // The Home branch resolves its Cubits from getIt; register seeded stubs so the
  // shell renders a populated feed synchronously (no drift / network).
  getIt
    ..registerFactory<FeedCubit>(
      () => StubFeedCubit(
        FeedState.loaded([_post(1), _post(2)], hasMore: false),
      ),
    )
    ..registerFactory<StoriesRailCubit>(StubStoriesRailCubit.new)
    ..registerLazySingleton<ToastService>(ToastService.new);
  addTearDown(getIt.reset);
  // Signed-in, profile-complete session → the shell lands on Home.
  final harness = SessionHarness(
    seededEmail: FakeAuthBackend.demoEmail,
    onboardingSeen: true,
    cachedProfileCompleted: true,
  );
  addTearDown(harness.dispose);
  await harness.controller.bootstrap();
  final router = AppRouter(harness.controller).router;
  await tester.pumpWidget(We36App(router: router));
  await tester.pumpAndSettle();
}

void main() {
  group('AdaptiveShell (US1)', () {
    testWidgets('phone width shows bottom nav + Home feed', (tester) async {
      await _pumpAppAt(tester, const Size(390, 800));
      expect(find.byType(BottomNav), findsOneWidget);
      expect(find.byType(SidebarRail), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(PostCard), findsWidgets);
    });

    testWidgets('tablet width shows sidebar rail, not bottom nav', (
      tester,
    ) async {
      await _pumpAppAt(tester, const Size(1000, 800));
      expect(find.byType(SidebarRail), findsOneWidget);
      expect(find.byType(BottomNav), findsNothing);
    });

    testWidgets('switching destinations preserves the shell', (tester) async {
      await _pumpAppAt(tester, const Size(390, 800));
      // Tap the Explore (2nd) bottom-nav slot via its label semantics.
      await tester.tap(find.bySemanticsLabel('Explore'));
      await tester.pumpAndSettle();
      expect(find.byType(ExplorePage), findsOneWidget);
      expect(find.byType(BottomNav), findsOneWidget);
    });
  });
}
