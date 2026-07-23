import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_state.dart';
import 'package:we36/features/profile/presentation/follow_list_page.dart';
import 'package:we36/features/profile/presentation/widgets/account_row_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #010 T039: the followers/following page renders two tabs, a search field, and
/// account rows. Driven by a seeded stub cubit (no drift).
class StubFollowListCubit extends Cubit<FollowListState>
    implements FollowListCubit {
  StubFollowListCubit(super.initialState);
  @override
  Future<void> init(String userId, FollowConnTab tab) async {}
  @override
  Future<void> switchTab(FollowConnTab tab) async {}
  @override
  Future<void> search(String query) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<bool> followRow(String userId) async => true;
  @override
  Future<bool> unfollowRow(String userId) async => true;
}

AccountRow _row(String username, {required bool following}) => AccountRow(
  user: UserSummary(
    id: 'u_$username',
    username: username,
    // Distinct from the handle: the row shows the bare handle over the real
    // name (design D3), so a distinct name avoids a duplicate-text match.
    displayName: username.replaceAll('_', ' '),
    isVerified: false,
  ),
  relationship: ViewerRelationship(
    following: following,
    requested: false,
    followsYou: false,
    blocking: false,
  ),
);

void main() {
  setUp(() => GetIt.I.registerLazySingleton<ToastService>(ToastService.new));
  tearDown(GetIt.I.reset);

  Widget host(FollowListState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<FollowListCubit>.value(
      value: StubFollowListCubit(state),
      child: const FollowListPage(username: 'alice_travel'),
    ),
  );

  testWidgets('renders tabs, search and rows', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(
        FollowListState.loaded(
          tab: FollowConnTab.followers,
          rows: [
            _row('bob_makes', following: false),
            _row('frank_photos', following: false),
          ],
          hasMore: false,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget); // the tab label
    expect(find.byType(AppSearchBar), findsOneWidget);
    expect(find.byType(AccountRowTile), findsNWidgets(2));
    expect(find.text('bob_makes'), findsOneWidget);
    expect(find.text('Follow'), findsNWidgets(2)); // both row controls
  });

  testWidgets('shows the empty-search state', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(
        const FollowListState.loaded(
          tab: FollowConnTab.followers,
          rows: [],
          hasMore: false,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('No accounts found'), findsOneWidget);
  });
}
