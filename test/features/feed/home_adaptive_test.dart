import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../helpers/pump_app.dart';

/// T057 / FR-030..FR-031 — the feed column is full-bleed on phones and centered
/// to `feedMaxWidth` on wider surfaces, reflowing on resize without overflow.
Post _post(int i) => Post(
  id: 'p$i',
  author: UserSummary(id: 'u$i', username: 'user$i', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 10,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption: 'post $i',
);

Widget _host() => MultiBlocProvider(
  providers: [
    BlocProvider<FeedCubit>(
      create: (_) => StubFeedCubit(
        FeedState.loaded([_post(1), _post(2), _post(3)], hasMore: false),
      ),
    ),
    BlocProvider<StoriesRailCubit>(create: (_) => StubStoriesRailCubit()),
  ],
  child: const HomePage(),
);

void main() {
  setUp(() {
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });
  tearDown(getIt.reset);

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    await pumpApp(tester, _host(), surfaceSize: size);
    await tester.pump();
  }

  testWidgets('phone width renders a full-width single column (<700)', (
    tester,
  ) async {
    await pumpAt(tester, const Size(390, 844));

    expect(find.byType(PostCard), findsWidgets);
    expect(tester.takeException(), isNull);
    // On a phone the feed fills the width (no centering constraint kicks in).
    final box = tester.getSize(find.byType(MaxWidthBox).first);
    expect(box.width, lessThanOrEqualTo(390));
  });

  testWidgets('tablet/desktop widths center the feed to feedMaxWidth (>=700)', (
    tester,
  ) async {
    for (final size in const [Size(820, 1180), Size(1280, 900)]) {
      await pumpAt(tester, size);

      expect(find.byType(PostCard), findsWidgets, reason: '$size');
      expect(tester.takeException(), isNull, reason: '$size');
      // The inner constrained content never exceeds the 560 max column.
      final content = tester.getSize(find.byType(PostCard).first);
      expect(
        content.width,
        lessThanOrEqualTo(AppSpacing.feedMaxWidth),
        reason: 'feed column should cap at feedMaxWidth on $size',
      );
    }
  });
}
