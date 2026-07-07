import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/router/adaptive_shell.dart';
import 'package:we36/core/router/centered_mobile.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/features/auth/presentation/forgot/forgot_password_page.dart';
import 'package:we36/features/auth/presentation/onboarding/onboarding_page.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_page.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:we36/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:we36/features/auth/presentation/splash/splash_page.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/caption_page.dart';
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/features/dev/presentation/gallery_page.dart';
import 'package:we36/features/dev/presentation/states_demo_page.dart';
import 'package:we36/features/dev/presentation/two_pane_demo_page.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/search_cubit.dart';
import 'package:we36/features/explore/presentation/discovery_grid_page.dart';
import 'package:we36/features/explore/presentation/explore_page.dart';
import 'package:we36/features/explore/presentation/search_page.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/home_page.dart';
import 'package:we36/features/messaging/presentation/messages_page.dart';
import 'package:we36/features/placeholder_page.dart';
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart';
import 'package:we36/features/post/presentation/post_detail_page.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:we36/features/profile/presentation/edit_profile_page.dart';
import 'package:we36/features/profile/presentation/follow_list_page.dart';
import 'package:we36/features/profile/presentation/my_profile_page.dart';
import 'package:we36/features/profile/presentation/user_profile_page.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:we36/features/reels/presentation/reel_compose_page.dart';
import 'package:we36/features/reels/presentation/reels_page.dart';
import 'package:we36/features/stories/presentation/compose/story_compose_page.dart';
import 'package:we36/features/stories/presentation/compose/story_pick_page.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart';
import 'package:we36/features/stories/presentation/story_viewer_page.dart';

/// The single app router (Constitution X): auth-guarded split, 5-tab
/// StatefulShellRoute, nav-less flow + pre-auth routes (wrapped centered-mobile
/// on tablet, FR-016). The redirect is driven by the app-wide
/// [SessionController] (#003): cold-start splash, auth + profile-completion
/// routing, forced sign-out.
@lazySingleton
class AppRouter {
  AppRouter(this._session) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _session,
      redirect: _redirect,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AdaptiveShell(navigationShell: navigationShell),
          branches: [
            _branch(
              AppRoutes.home,
              MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) {
                      final cubit = getIt<FeedCubit>();
                      unawaited(cubit.loadInitial());
                      return cubit;
                    },
                  ),
                  BlocProvider(
                    create: (_) {
                      final cubit = getIt<StoriesRailCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                  ),
                ],
                child: const HomePage(),
              ),
            ),
            _branch(
              AppRoutes.explore,
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ExploreCubit>();
                  unawaited(cubit.loadInitial());
                  return cubit;
                },
                child: const ExplorePage(),
              ),
            ),
            _branch(
              AppRoutes.reels,
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ReelsCubit>();
                  unawaited(cubit.loadInitial());
                  return cubit;
                },
                child: const ReelsPage(),
              ),
            ),
            _branch(AppRoutes.messages, const MessagesPage()),
            _branch(
              AppRoutes.profile,
              BlocProvider(
                create: (_) {
                  final cubit = getIt<MyProfileCubit>();
                  unawaited(cubit.loadInitial());
                  return cubit;
                },
                child: const MyProfilePage(),
              ),
            ),
          ],
        ),
        // Pre-auth zone (nav-less, centered-mobile on tablet)
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, _) => const SplashPage(),
        ),
        _flow(AppRoutes.onboarding, const OnboardingPage()),
        _flow(AppRoutes.signIn, const SignInPage()),
        _flow(AppRoutes.signUp, const SignUpPage()),
        _flow(AppRoutes.forgotPassword, const ForgotPasswordPage()),
        _flow(AppRoutes.profileSetup, const ProfileSetupPage()),
        // Flow routes (nav-less)
        // Story viewer — full-screen, edge-to-edge (no CenteredMobile wrap).
        GoRoute(
          path: AppRoutes.storyViewer,
          builder: (_, state) {
            final args = state.extra! as StoryViewerArgs;
            return StoryViewerPage(
              reels: args.reels,
              startIndex: args.startIndex,
            );
          },
        ),
        _flow(
          AppRoutes.notifications,
          const PlaceholderPage(title: 'Activity'),
        ),
        _flow(AppRoutes.settings, const PlaceholderPage(title: 'Settings')),
        // Search (#009 Screens 17+18) — full-screen nav-less; page-scoped
        // SearchCubit (live results) + RecentsCubit (history, loaded on open).
        GoRoute(
          path: AppRoutes.search,
          builder: (_, _) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<SearchCubit>()),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<RecentsCubit>();
                  unawaited(cubit.load());
                  return cubit;
                },
              ),
            ],
            child: const CenteredMobile(child: SearchPage()),
          ),
        ),
        // Hashtag & place pages (#009 Screen 19) — full-screen nav-less, deep-
        // linkable; page-scoped DiscoveryGridCubit.
        GoRoute(
          path: AppRoutes.hashtag,
          builder: (_, state) {
            final tag = state.pathParameters['tag']!;
            return BlocProvider(
              create: (_) {
                final cubit = getIt<DiscoveryGridCubit>();
                unawaited(cubit.initHashtag(tag));
                return cubit;
              },
              child: const CenteredMobile(child: DiscoveryGridPage()),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.place,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return BlocProvider(
              create: (_) {
                final cubit = getIt<DiscoveryGridCubit>();
                unawaited(cubit.initPlace(id));
                return cubit;
              },
              child: const CenteredMobile(child: DiscoveryGridPage()),
            );
          },
        ),
        // Another person's profile (#010 Screen 21) — full-screen nav-less,
        // deep-linkable. Page-scoped ProfileCubit.
        GoRoute(
          path: AppRoutes.userProfile,
          builder: (_, state) {
            final username = state.pathParameters['username']!;
            return BlocProvider(
              create: (_) {
                final cubit = getIt<ProfileCubit>();
                unawaited(cubit.loadInitial(username));
                return cubit;
              },
              child: UserProfilePage(username: username),
            );
          },
        ),
        // Edit my profile (#010 Screen 23) — full-screen nav-less.
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (_, state) => BlocProvider(
            create: (_) {
              final cubit = getIt<EditProfileCubit>();
              unawaited(cubit.load());
              return cubit;
            },
            child: EditProfilePage(
              initialAvatarUrl: state.extra as String?,
            ),
          ),
        ),
        // Followers / following (#010 Screen 22) — full-screen nav-less.
        GoRoute(
          path: AppRoutes.userConnections,
          builder: (_, state) {
            final username = state.pathParameters['username']!;
            // The followers/following endpoints are keyed by user id (UUID); the
            // opening profile page passes it via `extra` (the path carries the
            // human-readable username for the title / deep links).
            final userId = state.extra as String? ?? username;
            final tab = state.uri.queryParameters['tab'] == 'following'
                ? FollowConnTab.following
                : FollowConnTab.followers;
            return BlocProvider(
              create: (_) {
                final cubit = getIt<FollowListCubit>();
                unawaited(cubit.init(userId, tab));
                return cubit;
              },
              child: FollowListPage(username: username),
            );
          },
        ),
        // Post detail + comments (#006) — full-screen nav-less; the page itself
        // adapts to a two-column split on tablet (US6). Page-scoped CommentsCubit.
        GoRoute(
          path: AppRoutes.postDetail,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return BlocProvider(
              create: (_) {
                final cubit = getIt<CommentsCubit>();
                unawaited(cubit.load(id));
                return cubit;
              },
              child: const PostDetailPage(),
            );
          },
        ),
        // Create Post — compose flow (#007). One ShellRoute so pick→edit→caption
        // share the GalleryCubit + ComposeCubit; nav-less, centered on tablet.
        ShellRoute(
          builder: (context, state, child) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cubit = getIt<GalleryCubit>();
                  unawaited(cubit.loadInitial());
                  return cubit;
                },
              ),
              BlocProvider(create: (_) => getIt<ComposeCubit>()),
            ],
            child: CenteredMobile(child: child),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.composePick,
              builder: (_, _) => const PickPage(),
            ),
            GoRoute(
              path: AppRoutes.composeEdit,
              builder: (_, _) => const EditPage(),
            ),
            GoRoute(
              path: AppRoutes.composeCaption,
              builder: (_, _) => const CaptionPage(),
            ),
          ],
        ),
        // Create Reel — compose flow (#008). Nav-less, centered on tablet;
        // page-scoped ReelComposeCubit (pick→caption→publish).
        GoRoute(
          path: AppRoutes.reelCompose,
          builder: (_, _) => BlocProvider(
            create: (_) {
              final cubit = getIt<ReelComposeCubit>();
              unawaited(cubit.loadInitial());
              return cubit;
            },
            child: const CenteredMobile(child: ReelComposePage()),
          ),
        ),
        // Create Story — compose flow (#005). One ShellRoute so pick→compose
        // share the StoryGalleryCubit + StoryComposeCubit; nav-less, centered
        // on tablet (FR-001/016).
        ShellRoute(
          builder: (context, state, child) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cubit = getIt<StoryGalleryCubit>();
                  unawaited(cubit.loadInitial());
                  return cubit;
                },
              ),
              BlocProvider(create: (_) => getIt<StoryComposeCubit>()),
            ],
            child: CenteredMobile(child: child),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.storyComposePick,
              builder: (_, _) => const StoryPickPage(),
            ),
            GoRoute(
              path: AppRoutes.storyCompose,
              builder: (_, _) => const StoryComposePage(),
            ),
          ],
        ),
        // Dev harness
        _flow(AppRoutes.devGallery, const GalleryPage()),
        _flow(AppRoutes.devStates, const StatesDemoPage()),
        _flow(AppRoutes.devTwoPane, const TwoPaneDemoPage()),
      ],
    );
  }

  final SessionController _session;
  late final GoRouter router;

  /// Routes reachable while signed out (no auth required). Splash is handled
  /// separately (valid only while the session is resolving); `profileSetup` is
  /// auth-required.
  static final Set<String> _preAuth = {
    AppRoutes.onboarding,
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.forgotPassword,
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;

    // Still resolving the session on cold start → hold on Splash.
    if (_session.status == AuthStatus.unknown) {
      return loc == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final signedOutEntry = _session.onboardingSeen
        ? AppRoutes.signIn
        : AppRoutes.onboarding;

    if (!_session.isSignedIn) {
      // Resolved as signed out → leave splash for the entry screen.
      if (loc == AppRoutes.splash) return signedOutEntry;
      if (_preAuth.contains(loc)) return null;
      return signedOutEntry;
    }

    // Signed in but profile not completed → must finish setup.
    if (!_session.profileCompleted) {
      return loc == AppRoutes.profileSetup ? null : AppRoutes.profileSetup;
    }

    // Signed in + completed → keep out of splash / pre-auth flow / setup.
    if (loc == AppRoutes.splash ||
        loc == AppRoutes.profileSetup ||
        _preAuth.contains(loc)) {
      return AppRoutes.home;
    }
    return null;
  }

  static StatefulShellBranch _branch(String path, Widget child) {
    return StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (_, _) => child)],
    );
  }

  static GoRoute _flow(String path, Widget child) {
    return GoRoute(
      path: path,
      builder: (_, _) => CenteredMobile(child: child),
    );
  }
}
