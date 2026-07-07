import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_state.dart';
import 'package:we36/features/profile/presentation/my_profile_page.dart';
import 'package:we36/features/profile/presentation/widgets/profile_grid.dart';
import 'package:we36/features/profile/presentation/widgets/profile_stats.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/explore_test_doubles.dart';

/// #010 T024: the own-profile page renders header + stats + grid + Edit profile
/// (and no Follow control — FR-012). Driven by a seeded stub cubit (no drift).
class StubMyProfileCubit extends Cubit<MyProfileState>
    implements MyProfileCubit {
  StubMyProfileCubit(super.initialState);
  @override
  Future<void> loadInitial() async {}
  @override
  Future<void> refresh() async {}
  @override
  Future<void> switchTab(ProfileTab tab) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<void> retry() async {}
}

void main() {
  const view = ProfileView(
    user: User(
      id: 'u_demo',
      username: 'demo',
      displayName: 'You',
      isPrivate: false,
      isVerified: true,
      followersCount: 220,
      followingCount: 180,
      postsCount: 12,
      bio: 'This is me.',
    ),
    relationship: ViewerRelationship(
      following: false,
      requested: false,
      followsYou: false,
      blocking: false,
    ),
    isMe: true,
  );

  Widget host(MyProfileState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<MyProfileCubit>.value(
      value: StubMyProfileCubit(state),
      child: const MyProfilePage(),
    ),
  );

  testWidgets('renders header, stats, grid and Edit profile', (tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(
        MyProfileState.loaded(
          view: view,
          tab: ProfileTab.posts,
          grid: stubExploreItems(),
          hasMore: false,
          website: 'https://we36.app',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('You'), findsOneWidget);
    expect(find.text('@demo'), findsWidgets);
    expect(find.byType(ProfileStats), findsOneWidget);
    expect(find.byType(ProfileGrid), findsOneWidget);
    // Own profile shows Edit profile, never a Follow control (FR-012).
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Follow'), findsNothing);
  });

  testWidgets('shows the empty state when there are no posts', (tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      host(
        const MyProfileState.loaded(
          view: view,
          tab: ProfileTab.posts,
          grid: [],
          hasMore: false,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('No posts yet'), findsOneWidget);
  });
}
