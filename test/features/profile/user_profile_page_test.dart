import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/profile_state.dart';
import 'package:we36/features/profile/presentation/user_profile_page.dart';
import 'package:we36/features/profile/presentation/widgets/follow_button.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/explore_test_doubles.dart';

/// #010 T032: the other-user profile renders the header + Follow control, the
/// "Follows you" chip, and shows the unfollow confirm dialog.
class StubProfileCubit extends Cubit<ProfileState> implements ProfileCubit {
  StubProfileCubit(super.initialState);
  @override
  Future<void> loadInitial(String username) async {}
  @override
  Future<bool> follow() async => true;
  @override
  Future<bool> unfollow() async => true;
  @override
  Future<void> loadMore() async {}
}

ProfileView _view({required bool following, required bool followsYou}) =>
    ProfileView(
      user: const User(
        id: 'u_alice',
        username: 'alice_travel',
        displayName: 'Alice Travel',
        isPrivate: false,
        isVerified: true,
        followersCount: 1240,
        followingCount: 311,
        postsCount: 87,
        bio: 'Wandering.',
      ),
      relationship: ViewerRelationship(
        following: following,
        requested: false,
        followsYou: followsYou,
        blocking: false,
      ),
    );

void main() {
  setUp(() => GetIt.I.registerLazySingleton<ToastService>(ToastService.new));
  tearDown(GetIt.I.reset);

  Widget host(ProfileState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<ProfileCubit>.value(
      value: StubProfileCubit(state),
      child: const UserProfilePage(username: 'alice_travel'),
    ),
  );

  Future<void> pump(WidgetTester tester, ProfileState state) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host(state));
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('renders Follow, Message and Follows-you', (tester) async {
    await pump(
      tester,
      ProfileState.loaded(
        view: _view(following: false, followsYou: true),
        tab: ProfileTab.posts,
        grid: stubExploreItems(),
        hasMore: false,
      ),
    );
    expect(find.byType(FollowButton), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Follows you'), findsOneWidget);
  });

  testWidgets('tapping Following opens the unfollow confirm dialog', (
    tester,
  ) async {
    await pump(
      tester,
      ProfileState.loaded(
        view: _view(following: true, followsYou: false),
        tab: ProfileTab.posts,
        grid: stubExploreItems(),
        hasMore: false,
      ),
    );
    expect(find.text('Following'), findsOneWidget);
    await tester.tap(find.text('Following'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Unfollow?'), findsOneWidget);
  });
}
