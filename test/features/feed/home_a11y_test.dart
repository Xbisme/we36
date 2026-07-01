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
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/feed_test_doubles.dart';
import '../../helpers/pump_app.dart';

/// T058 / FR-030 / Constitution VI — the feed header exposes semantic labels and
/// the layout tolerates a large text scale without overflowing.
Post _post(int i) => Post(
  id: 'p$i',
  author: UserSummary(id: 'u$i', username: 'user$i', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 12,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
  caption:
      'A deliberately long caption that should wrap and never overflow even '
      'when the user has cranked up their preferred text scale to the maximum.',
);

Widget _host() => MultiBlocProvider(
  providers: [
    BlocProvider<FeedCubit>(
      create: (_) => StubFeedCubit(
        FeedState.loaded([_post(1), _post(2)], hasMore: false),
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

  testWidgets('header actions expose semantic labels (Activity + Messages)', (
    tester,
  ) async {
    await pumpApp(tester, _host(), surfaceSize: const Size(390, 844));
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // Activity merges its unread badge count into the node, so match a substring.
    expect(
      find.bySemanticsLabel(RegExp(RegExp.escape(l10n.feedActivity))),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(RegExp.escape(l10n.feedMessages))),
      findsOneWidget,
    );
    expect(find.byType(PostCard), findsWidgets);
  });

  testWidgets('feed tolerates a 2x text scale without overflow', (
    tester,
  ) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: _host(),
        ),
      ),
      surfaceSize: const Size(390, 844),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(PostCard), findsWidgets);
  });
}
