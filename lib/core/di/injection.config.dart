// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:we36/core/config/app_config.dart' as _i434;
import 'package:we36/core/data/api/api_client.dart' as _i784;
import 'package:we36/core/data/api/failure_mapper.dart' as _i56;
import 'package:we36/core/data/api/idempotency.dart' as _i222;
import 'package:we36/core/data/auth/auth_remote_data_source.dart' as _i1043;
import 'package:we36/core/data/auth/auth_repository.dart' as _i163;
import 'package:we36/core/data/auth/auth_repository_impl.dart' as _i235;
import 'package:we36/core/data/auth/fake_auth_backend.dart' as _i489;
import 'package:we36/core/data/auth/fake_auth_repository.dart' as _i548;
import 'package:we36/core/data/cache/app_database.dart' as _i270;
import 'package:we36/core/data/comments/comments_remote_data_source.dart'
    as _i814;
import 'package:we36/core/data/comments/comments_repository.dart' as _i552;
import 'package:we36/core/data/comments/comments_repository_impl.dart' as _i440;
import 'package:we36/core/data/comments/fake_comments_repository.dart' as _i67;
import 'package:we36/core/data/feed/fake_feed_repository.dart' as _i144;
import 'package:we36/core/data/feed/feed_remote_data_source.dart' as _i138;
import 'package:we36/core/data/feed/feed_repository.dart' as _i850;
import 'package:we36/core/data/feed/feed_repository_impl.dart' as _i907;
import 'package:we36/core/data/me/fake_me_repository.dart' as _i211;
import 'package:we36/core/data/me/me_remote_data_source.dart' as _i46;
import 'package:we36/core/data/me/me_repository.dart' as _i485;
import 'package:we36/core/data/me/me_repository_impl.dart' as _i858;
import 'package:we36/core/data/realtime/fake_realtime_client.dart' as _i261;
import 'package:we36/core/data/realtime/realtime_client.dart' as _i500;
import 'package:we36/core/data/reels/fake_reels_repository.dart' as _i713;
import 'package:we36/core/data/reels/reels_remote_data_source.dart' as _i746;
import 'package:we36/core/data/reels/reels_repository.dart' as _i724;
import 'package:we36/core/data/reels/reels_repository_impl.dart' as _i571;
import 'package:we36/core/data/stories/fake_stories_repository.dart' as _i154;
import 'package:we36/core/data/stories/own_story_store.dart' as _i767;
import 'package:we36/core/data/stories/stories_repository.dart' as _i112;
import 'package:we36/core/data/stories/stories_repository_impl.dart' as _i840;
import 'package:we36/core/data/user/fake_user_repository.dart' as _i156;
import 'package:we36/core/data/user/user_remote_data_source.dart' as _i528;
import 'package:we36/core/data/user/user_repository.dart' as _i247;
import 'package:we36/core/data/user/user_repository_impl.dart' as _i514;
import 'package:we36/core/presentation/toast.dart' as _i857;
import 'package:we36/core/router/app_router.dart' as _i485;
import 'package:we36/core/services/image_processing_service.dart' as _i12;
import 'package:we36/core/services/media_upload_service.dart' as _i547;
import 'package:we36/core/services/media_upload_service_fake.dart' as _i727;
import 'package:we36/core/services/photo_library_service.dart' as _i613;
import 'package:we36/core/services/session/auth_events.dart' as _i242;
import 'package:we36/core/services/session/local_flags.dart' as _i299;
import 'package:we36/core/services/session/real_token_refresher.dart' as _i266;
import 'package:we36/core/services/session/real_token_store.dart' as _i897;
import 'package:we36/core/services/session/session_controller.dart' as _i958;
import 'package:we36/core/services/session/token_refresher.dart' as _i200;
import 'package:we36/core/services/session/token_store.dart' as _i665;
import 'package:we36/core/services/story_image_composer.dart' as _i605;
import 'package:we36/core/utils/app_logger.dart' as _i433;
import 'package:we36/features/auth/data/oauth_token_source.dart' as _i873;
import 'package:we36/features/auth/data/real_oauth_token_source.dart' as _i350;
import 'package:we36/features/auth/domain/usecases/check_username.dart'
    as _i985;
import 'package:we36/features/auth/domain/usecases/request_password_reset.dart'
    as _i95;
import 'package:we36/features/auth/domain/usecases/reset_password.dart'
    as _i894;
import 'package:we36/features/auth/domain/usecases/setup_profile.dart' as _i800;
import 'package:we36/features/auth/domain/usecases/sign_in.dart' as _i53;
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart'
    as _i915;
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart'
    as _i594;
import 'package:we36/features/auth/domain/usecases/sign_out.dart' as _i440;
import 'package:we36/features/auth/domain/usecases/sign_up.dart' as _i601;
import 'package:we36/features/auth/presentation/forgot/forgot_password_cubit.dart'
    as _i764;
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart'
    as _i206;
import 'package:we36/features/auth/presentation/onboarding/onboarding_cubit.dart'
    as _i902;
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_cubit.dart'
    as _i16;
import 'package:we36/features/auth/presentation/sign_in/sign_in_cubit.dart'
    as _i942;
import 'package:we36/features/auth/presentation/sign_up/sign_up_cubit.dart'
    as _i30;
import 'package:we36/features/compose/data/compose_draft_store.dart' as _i988;
import 'package:we36/features/compose/data/create_post_repository_fake.dart'
    as _i792;
import 'package:we36/features/compose/data/create_post_repository_real.dart'
    as _i794;
import 'package:we36/features/compose/domain/create_post_repository.dart'
    as _i1030;
import 'package:we36/features/compose/domain/usecases/publish_post.dart'
    as _i602;
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart'
    as _i238;
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart'
    as _i772;
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart' as _i321;
import 'package:we36/features/feed/presentation/feed_cubit.dart' as _i992;
import 'package:we36/features/post/domain/usecases/comment_usecases.dart'
    as _i140;
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart'
    as _i321;
import 'package:we36/features/reels/domain/usecases/reel_comment_usecases.dart'
    as _i893;
import 'package:we36/features/reels/domain/usecases/reel_engagement_usecases.dart'
    as _i728;
import 'package:we36/features/reels/domain/usecases/reel_feed_usecases.dart'
    as _i740;
import 'package:we36/features/reels/presentation/cubit/reel_comments_cubit.dart'
    as _i989;
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart'
    as _i846;
import 'package:we36/features/stories/data/create_story_repository.dart'
    as _i674;
import 'package:we36/features/stories/data/create_story_repository_fake.dart'
    as _i159;
import 'package:we36/features/stories/data/create_story_repository_real.dart'
    as _i649;
import 'package:we36/features/stories/domain/usecases/publish_story.dart'
    as _i287;
import 'package:we36/features/stories/domain/usecases/story_usecases.dart'
    as _i351;
import 'package:we36/features/stories/domain/usecases/watch_own_story_changes.dart'
    as _i897;
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart'
    as _i433;
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart'
    as _i858;
import 'package:we36/features/stories/presentation/stories_rail_cubit.dart'
    as _i270;
import 'package:we36/features/stories/presentation/story_viewer_cubit.dart'
    as _i169;

const String _real = 'real';
const String _fake = 'fake';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i56.FailureMapper>(() => const _i56.FailureMapper());
    gh.lazySingleton<_i222.IdempotencyKeys>(() => _i222.IdempotencyKeys());
    gh.lazySingleton<_i270.AppDatabase>(() => _i270.AppDatabase());
    gh.lazySingleton<_i767.OwnStoryStore>(
      () => _i767.OwnStoryStore.create(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i857.ToastService>(() => _i857.ToastService());
    gh.lazySingleton<_i12.ImageProcessingService>(
      () => const _i12.ImageProcessingService(),
    );
    gh.lazySingleton<_i605.StoryImageComposer>(
      () => const _i605.StoryImageComposer(),
    );
    gh.lazySingleton<_i433.AppLogger>(() => const _i433.AppLogger());
    gh.lazySingleton<_i500.RealtimeClient>(
      () => _i500.SocketIoRealtimeClient(
        gh<_i434.AppConfig>(),
        gh<_i433.AppLogger>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i112.StoriesRepository>(
      () => _i154.FakeStoriesRepository(
        gh<_i270.AppDatabase>(),
        gh<_i767.OwnStoryStore>(),
      ),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i613.PhotoLibraryService>(
      () => _i613.RealPhotoLibraryService(),
    );
    gh.lazySingleton<_i665.TokenStore>(() => _i897.RealTokenStore());
    gh.lazySingleton<_i988.ComposeDraftStore>(
      () => _i988.ComposeDraftStore(gh<_i270.AppDatabase>()),
    );
    gh.lazySingleton<_i299.LocalFlags>(() => _i299.LocalFlagsImpl());
    gh.lazySingleton<_i674.CreateStoryRepository>(
      () => const _i649.RealCreateStoryRepository(),
      registerFor: {_real},
    );
    gh.factory<_i772.GalleryCubit>(
      () => _i772.GalleryCubit(gh<_i613.PhotoLibraryService>()),
    );
    gh.factory<_i858.StoryGalleryCubit>(
      () => _i858.StoryGalleryCubit(gh<_i613.PhotoLibraryService>()),
    );
    gh.lazySingleton<_i242.AuthEventsSink>(() => _i242.AuthEvents());
    gh.lazySingleton<_i112.StoriesRepository>(
      () => _i840.StoriesRepositoryImpl(gh<_i270.AppDatabase>()),
      registerFor: {_real},
    );
    gh.factory<_i897.WatchOwnStoryChanges>(
      () => _i897.WatchOwnStoryChanges(gh<_i767.OwnStoryStore>()),
    );
    gh.lazySingleton<_i724.ReelsRepository>(
      () => _i713.FakeReelsRepository(gh<_i270.AppDatabase>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i552.CommentsRepository>(
      () => _i67.FakeCommentsRepository.create(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i873.OAuthTokenSource>(
      () => _i350.RealOAuthTokenSource(gh<_i434.AppConfig>()),
      registerFor: {_real},
    );
    gh.factory<_i351.LoadStoryReels>(
      () => _i351.LoadStoryReels(gh<_i112.StoriesRepository>()),
    );
    gh.factory<_i351.WatchSeenSegments>(
      () => _i351.WatchSeenSegments(gh<_i112.StoriesRepository>()),
    );
    gh.factory<_i351.MarkSegmentSeen>(
      () => _i351.MarkSegmentSeen(gh<_i112.StoriesRepository>()),
    );
    gh.factory<_i351.LikeStorySegment>(
      () => _i351.LikeStorySegment(gh<_i112.StoriesRepository>()),
    );
    gh.lazySingleton<_i489.FakeAuthBackend>(
      () => _i489.FakeAuthBackend(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i163.AuthRepository>(
      () => _i548.FakeAuthRepository(gh<_i489.FakeAuthBackend>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i547.MediaUploadService>(
      () => _i727.FakeMediaUploadService(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i1030.CreatePostRepository>(
      () => _i792.FakeCreatePostRepository(gh<_i270.AppDatabase>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i200.TokenRefresher>(
      () => _i200.FakeTokenRefresher(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i873.OAuthTokenSource>(
      () => const _i873.FakeOAuthTokenSource(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i247.UserRepository>(
      () => _i156.FakeUserRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i500.RealtimeClient>(
      () => _i261.FakeRealtimeClient(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i850.FeedRepository>(
      () => _i144.FakeFeedRepository(gh<_i270.AppDatabase>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i200.TokenRefresher>(
      () => _i266.RealTokenRefresher(
        gh<_i434.AppConfig>(),
        gh<_i665.TokenStore>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i674.CreateStoryRepository>(
      () => _i159.FakeCreateStoryRepository(
        gh<_i547.MediaUploadService>(),
        gh<_i270.AppDatabase>(),
        gh<_i767.OwnStoryStore>(),
      ),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i485.MeRepository>(
      () => _i211.FakeMeRepository(
        gh<_i489.FakeAuthBackend>(),
        gh<_i665.TokenStore>(),
      ),
      registerFor: {_fake},
    );
    gh.factory<_i169.StoryViewerCubit>(
      () => _i169.StoryViewerCubit(
        gh<_i351.MarkSegmentSeen>(),
        gh<_i351.LikeStorySegment>(),
      ),
    );
    gh.factory<_i270.StoriesRailCubit>(
      () => _i270.StoriesRailCubit(
        gh<_i351.LoadStoryReels>(),
        gh<_i351.WatchSeenSegments>(),
        gh<_i897.WatchOwnStoryChanges>(),
      ),
    );
    gh.lazySingleton<_i784.ApiClient>(
      () => _i784.ApiClient(
        gh<_i434.AppConfig>(),
        gh<_i665.TokenStore>(),
        gh<_i200.TokenRefresher>(),
        gh<_i242.AuthEventsSink>(),
        gh<_i433.AppLogger>(),
        gh<_i56.FailureMapper>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i287.PublishStory>(
      () => _i287.PublishStory(gh<_i674.CreateStoryRepository>()),
    );
    gh.lazySingleton<_i547.MediaUploadService>(
      () => _i547.RealMediaUploadService(gh<_i784.ApiClient>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i1043.AuthRemoteDataSource>(
      () => _i1043.AuthRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i814.CommentsRemoteDataSource>(
      () => _i814.CommentsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i138.FeedRemoteDataSource>(
      () => _i138.FeedRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i46.MeRemoteDataSource>(
      () => _i46.MeRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i746.ReelsRemoteDataSource>(
      () => _i746.ReelsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i528.UserRemoteDataSource>(
      () => _i528.UserRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i485.MeRepository>(
      () => _i858.MeRepositoryImpl(
        gh<_i46.MeRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i433.StoryComposeCubit>(
      () => _i433.StoryComposeCubit(
        gh<_i287.PublishStory>(),
        gh<_i605.StoryImageComposer>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.lazySingleton<_i1030.CreatePostRepository>(
      () => _i794.RealCreatePostRepository(
        gh<_i784.ApiClient>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i958.SessionController>(
      () => _i958.SessionController(
        gh<_i665.TokenStore>(),
        gh<_i485.MeRepository>(),
        gh<_i299.LocalFlags>(),
        gh<_i270.AppDatabase>(),
        gh<_i767.OwnStoryStore>(),
        gh<_i242.AuthEventsSink>(),
      ),
    );
    gh.lazySingleton<_i552.CommentsRepository>(
      () => _i440.CommentsRepositoryImpl(gh<_i814.CommentsRemoteDataSource>()),
      registerFor: {_real},
    );
    gh.factory<_i902.OnboardingCubit>(
      () => _i902.OnboardingCubit(gh<_i958.SessionController>()),
    );
    gh.lazySingleton<_i485.AppRouter>(
      () => _i485.AppRouter(gh<_i958.SessionController>()),
    );
    gh.factory<_i602.PublishPost>(
      () => _i602.PublishPost(
        gh<_i613.PhotoLibraryService>(),
        gh<_i12.ImageProcessingService>(),
        gh<_i547.MediaUploadService>(),
        gh<_i1030.CreatePostRepository>(),
      ),
    );
    gh.lazySingleton<_i724.ReelsRepository>(
      () => _i571.ReelsRepositoryImpl(
        gh<_i746.ReelsRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i247.UserRepository>(
      () => _i514.UserRepositoryImpl(
        gh<_i528.UserRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i163.AuthRepository>(
      () => _i235.AuthRepositoryImpl(gh<_i1043.AuthRemoteDataSource>()),
      registerFor: {_real},
    );
    gh.factory<_i53.SignIn>(
      () => _i53.SignIn(
        gh<_i163.AuthRepository>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.factory<_i601.SignUp>(
      () => _i601.SignUp(
        gh<_i163.AuthRepository>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.lazySingleton<_i850.FeedRepository>(
      () => _i907.FeedRepositoryImpl(
        gh<_i138.FeedRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i238.ComposeCubit>(
      () => _i238.ComposeCubit(
        gh<_i602.PublishPost>(),
        gh<_i988.ComposeDraftStore>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i140.AddComment>(
      () => _i140.AddComment(
        gh<_i552.CommentsRepository>(),
        gh<_i850.FeedRepository>(),
      ),
    );
    gh.factory<_i140.DeleteComment>(
      () => _i140.DeleteComment(
        gh<_i552.CommentsRepository>(),
        gh<_i850.FeedRepository>(),
      ),
    );
    gh.factory<_i728.ToggleReelLike>(
      () => _i728.ToggleReelLike(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i728.ToggleReelSave>(
      () => _i728.ToggleReelSave(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i728.DeleteReel>(
      () => _i728.DeleteReel(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i740.WatchReelsFeed>(
      () => _i740.WatchReelsFeed(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i740.LoadReels>(
      () => _i740.LoadReels(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i740.LoadMoreReels>(
      () => _i740.LoadMoreReels(gh<_i724.ReelsRepository>()),
    );
    gh.factory<_i942.SignInCubit>(() => _i942.SignInCubit(gh<_i53.SignIn>()));
    gh.factory<_i800.SetupProfile>(
      () => _i800.SetupProfile(
        gh<_i485.MeRepository>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.factory<_i440.SignOut>(
      () => _i440.SignOut(
        gh<_i163.AuthRepository>(),
        gh<_i665.TokenStore>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.factory<_i140.LoadComments>(
      () => _i140.LoadComments(gh<_i552.CommentsRepository>()),
    );
    gh.factory<_i140.LoadReplies>(
      () => _i140.LoadReplies(gh<_i552.CommentsRepository>()),
    );
    gh.factory<_i140.ToggleCommentLike>(
      () => _i140.ToggleCommentLike(gh<_i552.CommentsRepository>()),
    );
    gh.factory<_i140.ReportComment>(
      () => _i140.ReportComment(gh<_i552.CommentsRepository>()),
    );
    gh.factory<_i846.ReelsCubit>(
      () => _i846.ReelsCubit(
        gh<_i740.WatchReelsFeed>(),
        gh<_i740.LoadReels>(),
        gh<_i740.LoadMoreReels>(),
        gh<_i728.ToggleReelLike>(),
        gh<_i728.ToggleReelSave>(),
        gh<_i728.DeleteReel>(),
      ),
    );
    gh.factory<_i893.AddReelComment>(
      () => _i893.AddReelComment(
        gh<_i552.CommentsRepository>(),
        gh<_i724.ReelsRepository>(),
      ),
    );
    gh.factory<_i893.DeleteReelComment>(
      () => _i893.DeleteReelComment(
        gh<_i552.CommentsRepository>(),
        gh<_i724.ReelsRepository>(),
      ),
    );
    gh.factory<_i140.WatchPost>(
      () => _i140.WatchPost(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i915.SignInWithApple>(
      () => _i915.SignInWithApple(
        gh<_i873.OAuthTokenSource>(),
        gh<_i163.AuthRepository>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.factory<_i594.SignInWithGoogle>(
      () => _i594.SignInWithGoogle(
        gh<_i873.OAuthTokenSource>(),
        gh<_i163.AuthRepository>(),
        gh<_i958.SessionController>(),
      ),
    );
    gh.factory<_i985.CheckUsername>(
      () => _i985.CheckUsername(gh<_i163.AuthRepository>()),
    );
    gh.factory<_i95.RequestPasswordReset>(
      () => _i95.RequestPasswordReset(gh<_i163.AuthRepository>()),
    );
    gh.factory<_i894.ResetPassword>(
      () => _i894.ResetPassword(gh<_i163.AuthRepository>()),
    );
    gh.factory<_i989.ReelCommentsCubit>(
      () => _i989.ReelCommentsCubit(
        gh<_i140.LoadComments>(),
        gh<_i140.LoadReplies>(),
        gh<_i893.AddReelComment>(),
        gh<_i140.ToggleCommentLike>(),
        gh<_i893.DeleteReelComment>(),
        gh<_i140.ReportComment>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i321.WatchFeed>(
      () => _i321.WatchFeed(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i321.LoadFeed>(
      () => _i321.LoadFeed(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i321.LoadMoreFeed>(
      () => _i321.LoadMoreFeed(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i321.ToggleLike>(
      () => _i321.ToggleLike(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i321.ToggleSave>(
      () => _i321.ToggleSave(gh<_i850.FeedRepository>()),
    );
    gh.factory<_i30.SignUpCubit>(() => _i30.SignUpCubit(gh<_i601.SignUp>()));
    gh.factory<_i206.OAuthCubit>(
      () => _i206.OAuthCubit(
        gh<_i594.SignInWithGoogle>(),
        gh<_i915.SignInWithApple>(),
      ),
    );
    gh.factory<_i16.ProfileSetupCubit>(
      () => _i16.ProfileSetupCubit(
        gh<_i985.CheckUsername>(),
        gh<_i800.SetupProfile>(),
      ),
    );
    gh.factory<_i992.FeedCubit>(
      () => _i992.FeedCubit(
        gh<_i321.WatchFeed>(),
        gh<_i321.LoadFeed>(),
        gh<_i321.LoadMoreFeed>(),
        gh<_i321.ToggleLike>(),
        gh<_i321.ToggleSave>(),
      ),
    );
    gh.factory<_i321.CommentsCubit>(
      () => _i321.CommentsCubit(
        gh<_i140.WatchPost>(),
        gh<_i140.LoadComments>(),
        gh<_i140.LoadReplies>(),
        gh<_i140.AddComment>(),
        gh<_i140.ToggleCommentLike>(),
        gh<_i140.DeleteComment>(),
        gh<_i140.ReportComment>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i764.ForgotPasswordCubit>(
      () => _i764.ForgotPasswordCubit(
        gh<_i95.RequestPasswordReset>(),
        gh<_i894.ResetPassword>(),
      ),
    );
    return this;
  }
}
