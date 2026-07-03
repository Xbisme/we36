import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/presentation/widgets/account_result_row.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #009 US5 (T052): screen-reader labels + large text scale on discovery widgets.
void main() {
  ExploreItem postItem() => ExploreItem(
    kind: ExploreItemKind.post,
    post: Post(
      id: 'p1',
      author: const UserSummary(id: 'u', username: 'maya', isVerified: false),
      media: [
        const PostMedia(
          position: 0,
          media: Media(
            id: 'm',
            kind: MediaKind.image,
            status: MediaStatus.ready,
          ),
        ),
      ],
      hashtags: const [],
      taggedUsers: const [],
      commentsDisabled: false,
      likeCount: 0,
      saveCount: 0,
      commentCount: 0,
      viewerHasLiked: false,
      viewerHasSaved: false,
      createdAt: DateTime.utc(2026, 7),
    ),
  );

  Widget host(Widget child, {double scale = 1}) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        body: Center(child: SizedBox(width: 375, child: child)),
      ),
    ),
  );

  testWidgets('grid tile announces photo vs reel', (tester) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 120,
          height: 120,
          child: DiscoveryGridTile(item: postItem(), onTap: () {}),
        ),
      ),
    );
    expect(find.bySemanticsLabel(RegExp('Photo')), findsOneWidget);
  });

  testWidgets('account row is labelled and survives 2x text scale', (
    tester,
  ) async {
    final row = AccountResultRow(
      result: const AccountResult(
        user: UserSummary(
          id: 'u',
          username: 'alice_travel',
          displayName: 'Alice Travel',
          isVerified: true,
        ),
        relationship: ViewerRelationship(
          following: true,
          requested: false,
          followsYou: false,
          blocking: false,
        ),
      ),
      onTap: () {},
    );
    await tester.pumpWidget(host(row, scale: 2));
    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel(RegExp('alice_travel')), findsOneWidget);
  });
}
