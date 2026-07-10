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
import 'package:we36/core/data/close_friends/close_friends_repository.dart'
    as _i42;
import 'package:we36/core/data/close_friends/close_friends_repository_impl.dart'
    as _i753;
import 'package:we36/core/data/close_friends/fake_close_friends_repository.dart'
    as _i1068;
import 'package:we36/core/data/collections/collections_remote_data_source.dart'
    as _i768;
import 'package:we36/core/data/collections/collections_repository.dart'
    as _i603;
import 'package:we36/core/data/collections/collections_repository_impl.dart'
    as _i776;
import 'package:we36/core/data/collections/fake_collections_repository.dart'
    as _i617;
import 'package:we36/core/data/comments/comments_remote_data_source.dart'
    as _i814;
import 'package:we36/core/data/comments/comments_repository.dart' as _i552;
import 'package:we36/core/data/comments/comments_repository_impl.dart' as _i440;
import 'package:we36/core/data/comments/fake_comments_repository.dart' as _i67;
import 'package:we36/core/data/discovery/discovery_remote_data_source.dart'
    as _i191;
import 'package:we36/core/data/discovery/discovery_repository.dart' as _i550;
import 'package:we36/core/data/discovery/discovery_repository_impl.dart'
    as _i943;
import 'package:we36/core/data/discovery/fake_discovery_repository.dart'
    as _i751;
import 'package:we36/core/data/feed/fake_feed_repository.dart' as _i144;
import 'package:we36/core/data/feed/feed_remote_data_source.dart' as _i138;
import 'package:we36/core/data/feed/feed_repository.dart' as _i850;
import 'package:we36/core/data/feed/feed_repository_impl.dart' as _i907;
import 'package:we36/core/data/me/fake_me_repository.dart' as _i211;
import 'package:we36/core/data/me/me_remote_data_source.dart' as _i46;
import 'package:we36/core/data/me/me_repository.dart' as _i485;
import 'package:we36/core/data/me/me_repository_impl.dart' as _i858;
import 'package:we36/core/data/messaging/fake_messaging_repository.dart'
    as _i900;
import 'package:we36/core/data/messaging/messaging_remote_data_source.dart'
    as _i962;
import 'package:we36/core/data/messaging/messaging_repository.dart' as _i1044;
import 'package:we36/core/data/messaging/messaging_repository_impl.dart'
    as _i948;
import 'package:we36/core/data/moderation/block_actions.dart' as _i111;
import 'package:we36/core/data/moderation/block_repository.dart' as _i524;
import 'package:we36/core/data/moderation/block_repository_impl.dart' as _i221;
import 'package:we36/core/data/moderation/blocked_users_store.dart' as _i18;
import 'package:we36/core/data/moderation/fake_block_repository.dart' as _i617;
import 'package:we36/core/data/moderation/report_repository.dart' as _i172;
import 'package:we36/core/data/notifications/fake_notifications_repository.dart'
    as _i200;
import 'package:we36/core/data/notifications/notifications_remote_data_source.dart'
    as _i102;
import 'package:we36/core/data/notifications/notifications_repository.dart'
    as _i342;
import 'package:we36/core/data/notifications/notifications_repository_impl.dart'
    as _i832;
import 'package:we36/core/data/profile/fake_profile_repository.dart' as _i214;
import 'package:we36/core/data/profile/profile_remote_data_source.dart'
    as _i765;
import 'package:we36/core/data/profile/profile_repository.dart' as _i124;
import 'package:we36/core/data/profile/profile_repository_impl.dart' as _i521;
import 'package:we36/core/data/profile/relationship_store.dart' as _i1059;
import 'package:we36/core/data/realtime/fake_realtime_client.dart' as _i261;
import 'package:we36/core/data/realtime/realtime_client.dart' as _i500;
import 'package:we36/core/data/reels/fake_reels_repository.dart' as _i713;
import 'package:we36/core/data/reels/reels_remote_data_source.dart' as _i746;
import 'package:we36/core/data/reels/reels_repository.dart' as _i724;
import 'package:we36/core/data/reels/reels_repository_impl.dart' as _i571;
import 'package:we36/core/data/settings/fake_settings_repository.dart' as _i143;
import 'package:we36/core/data/settings/settings_remote_data_source.dart'
    as _i710;
import 'package:we36/core/data/settings/settings_repository.dart' as _i1043;
import 'package:we36/core/data/settings/settings_repository_impl.dart' as _i996;
import 'package:we36/core/data/social/fake_follow_requests_repository.dart'
    as _i426;
import 'package:we36/core/data/social/follow_requests_remote_data_source.dart'
    as _i625;
import 'package:we36/core/data/social/follow_requests_repository.dart' as _i323;
import 'package:we36/core/data/social/follow_requests_repository_impl.dart'
    as _i426;
import 'package:we36/core/data/stories/fake_stories_repository.dart' as _i154;
import 'package:we36/core/data/stories/own_story_store.dart' as _i767;
import 'package:we36/core/data/stories/stories_repository.dart' as _i112;
import 'package:we36/core/data/stories/stories_repository_impl.dart' as _i840;
import 'package:we36/core/data/user/fake_user_repository.dart' as _i156;
import 'package:we36/core/data/user/user_remote_data_source.dart' as _i528;
import 'package:we36/core/data/user/user_repository.dart' as _i247;
import 'package:we36/core/data/user/user_repository_impl.dart' as _i514;
import 'package:we36/core/presentation/slots/messaging_launcher.dart' as _i779;
import 'package:we36/core/presentation/slots/save_to_collection_launcher.dart'
    as _i943;
import 'package:we36/core/presentation/slots/saved_tab_slot.dart' as _i860;
import 'package:we36/core/presentation/toast.dart' as _i857;
import 'package:we36/core/router/app_router.dart' as _i485;
import 'package:we36/core/services/image_processing_service.dart' as _i12;
import 'package:we36/core/services/media_upload_service.dart' as _i547;
import 'package:we36/core/services/media_upload_service_fake.dart' as _i727;
import 'package:we36/core/services/messaging/messaging_badge.dart' as _i1004;
import 'package:we36/core/services/notifications/notifications_badge.dart'
    as _i417;
import 'package:we36/core/services/photo_library_service.dart' as _i613;
import 'package:we36/core/services/preferences/app_preferences.dart' as _i316;
import 'package:we36/core/services/preferences/presence_visibility.dart'
    as _i861;
import 'package:we36/core/services/push/fake_push_service.dart' as _i965;
import 'package:we36/core/services/push/firebase_push_service.dart' as _i749;
import 'package:we36/core/services/push/push_registration_service.dart'
    as _i315;
import 'package:we36/core/services/push/push_service.dart' as _i862;
import 'package:we36/core/services/realtime/messaging_realtime_service.dart'
    as _i951;
import 'package:we36/core/services/realtime/notifications_realtime_service.dart'
    as _i776;
import 'package:we36/core/services/realtime/realtime_connection_manager.dart'
    as _i35;
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
import 'package:we36/features/collections/domain/usecases/collection_items_usecases.dart'
    as _i706;
import 'package:we36/features/collections/domain/usecases/collections_usecases.dart'
    as _i1008;
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart'
    as _i416;
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart'
    as _i451;
import 'package:we36/features/collections/presentation/cubit/collection_detail_cubit.dart'
    as _i192;
import 'package:we36/features/collections/presentation/cubit/collection_edit_cubit.dart'
    as _i142;
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart'
    as _i556;
import 'package:we36/features/collections/presentation/cubit/save_to_collection_cubit.dart'
    as _i1059;
import 'package:we36/features/collections/presentation/save_to_collection_launcher_impl.dart'
    as _i805;
import 'package:we36/features/collections/presentation/saved_tab_slot_impl.dart'
    as _i1008;
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
import 'package:we36/features/explore/domain/usecases/discovery_page_usecases.dart'
    as _i619;
import 'package:we36/features/explore/domain/usecases/explore_usecases.dart'
    as _i93;
import 'package:we36/features/explore/domain/usecases/recents_usecases.dart'
    as _i488;
import 'package:we36/features/explore/domain/usecases/search_usecases.dart'
    as _i96;
import 'package:we36/features/explore/presentation/cubit/discovery_grid_cubit.dart'
    as _i831;
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart'
    as _i569;
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart'
    as _i812;
import 'package:we36/features/explore/presentation/cubit/search_cubit.dart'
    as _i889;
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart' as _i321;
import 'package:we36/features/feed/presentation/feed_cubit.dart' as _i992;
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart'
    as _i973;
import 'package:we36/features/messaging/domain/usecases/conversations_usecases.dart'
    as _i534;
import 'package:we36/features/messaging/domain/usecases/new_message_usecases.dart'
    as _i587;
import 'package:we36/features/messaging/presentation/cubit/chat_cubit.dart'
    as _i966;
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart'
    as _i385;
import 'package:we36/features/messaging/presentation/cubit/messaging_shell_cubit.dart'
    as _i123;
import 'package:we36/features/messaging/presentation/cubit/new_message_cubit.dart'
    as _i550;
import 'package:we36/features/messaging/presentation/messaging_launcher_impl.dart'
    as _i297;
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart'
    as _i685;
import 'package:we36/features/notifications/presentation/cubit/notifications_cubit.dart'
    as _i919;
import 'package:we36/features/notifications/presentation/cubit/push_permission_cubit.dart'
    as _i297;
import 'package:we36/features/post/domain/usecases/comment_usecases.dart'
    as _i140;
import 'package:we36/features/post/presentation/cubit/comments_cubit.dart'
    as _i321;
import 'package:we36/features/profile/domain/usecases/edit_profile_usecases.dart'
    as _i305;
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart'
    as _i531;
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart'
    as _i631;
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart'
    as _i983;
import 'package:we36/features/profile/presentation/cubit/edit_profile_cubit.dart'
    as _i391;
import 'package:we36/features/profile/presentation/cubit/follow_list_cubit.dart'
    as _i818;
import 'package:we36/features/profile/presentation/cubit/my_profile_cubit.dart'
    as _i895;
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart'
    as _i263;
import 'package:we36/features/reels/domain/usecases/publish_reel.dart' as _i51;
import 'package:we36/features/reels/domain/usecases/reel_comment_usecases.dart'
    as _i893;
import 'package:we36/features/reels/domain/usecases/reel_engagement_usecases.dart'
    as _i728;
import 'package:we36/features/reels/domain/usecases/reel_feed_usecases.dart'
    as _i740;
import 'package:we36/features/reels/presentation/cubit/reel_comments_cubit.dart'
    as _i989;
import 'package:we36/features/reels/presentation/cubit/reel_compose_cubit.dart'
    as _i762;
import 'package:we36/features/reels/presentation/cubit/reels_cubit.dart'
    as _i846;
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart'
    as _i183;
import 'package:we36/features/settings/presentation/cubit/blocked_accounts_cubit.dart'
    as _i547;
import 'package:we36/features/settings/presentation/cubit/close_friends_cubit.dart'
    as _i465;
import 'package:we36/features/settings/presentation/cubit/follow_requests_cubit.dart'
    as _i1025;
import 'package:we36/features/settings/presentation/cubit/settings_cubit.dart'
    as _i708;
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
    gh.factory<_i123.MessagingShellCubit>(() => _i123.MessagingShellCubit());
    gh.lazySingleton<_i56.FailureMapper>(() => const _i56.FailureMapper());
    gh.lazySingleton<_i222.IdempotencyKeys>(() => _i222.IdempotencyKeys());
    gh.lazySingleton<_i270.AppDatabase>(() => _i270.AppDatabase());
    gh.lazySingleton<_i18.BlockedUsersStore>(() => _i18.BlockedUsersStore());
    gh.lazySingleton<_i1059.RelationshipStore>(
      () => _i1059.RelationshipStore(),
    );
    gh.lazySingleton<_i767.OwnStoryStore>(
      () => _i767.OwnStoryStore.create(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i857.ToastService>(() => _i857.ToastService());
    gh.lazySingleton<_i12.ImageProcessingService>(
      () => const _i12.ImageProcessingService(),
    );
    gh.lazySingleton<_i417.NotificationsBadge>(
      () => _i417.NotificationsBadge(),
    );
    gh.lazySingleton<_i861.PresenceVisibility>(
      () => _i861.PresenceVisibility(),
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
    gh.lazySingleton<_i943.SaveToCollectionLauncher>(
      () => const _i805.SaveToCollectionLauncherImpl(),
    );
    gh.lazySingleton<_i316.AppPreferences>(() => _i316.AppPreferencesImpl());
    gh.lazySingleton<_i299.LocalFlags>(() => _i299.LocalFlagsImpl());
    gh.factory<_i772.GalleryCubit>(
      () => _i772.GalleryCubit(gh<_i613.PhotoLibraryService>()),
    );
    gh.factory<_i858.StoryGalleryCubit>(
      () => _i858.StoryGalleryCubit(gh<_i613.PhotoLibraryService>()),
    );
    gh.lazySingleton<_i242.AuthEventsSink>(() => _i242.AuthEvents());
    gh.lazySingleton<_i860.SavedTabSlot>(() => const _i1008.SavedTabSlotImpl());
    gh.lazySingleton<_i862.PushService>(
      () => _i749.FirebasePushService(gh<_i433.AppLogger>()),
      registerFor: {_real},
    );
    gh.factory<_i897.WatchOwnStoryChanges>(
      () => _i897.WatchOwnStoryChanges(gh<_i767.OwnStoryStore>()),
    );
    gh.lazySingleton<_i183.AppSettingsCubit>(
      () => _i183.AppSettingsCubit(gh<_i316.AppPreferences>()),
    );
    gh.lazySingleton<_i724.ReelsRepository>(
      () => _i713.FakeReelsRepository(gh<_i270.AppDatabase>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i1043.SettingsRepository>(
      () => _i143.FakeSettingsRepository(),
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
    gh.lazySingleton<_i342.NotificationsRepository>(
      () => _i200.FakeNotificationsRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i489.FakeAuthBackend>(
      () => _i489.FakeAuthBackend(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i163.AuthRepository>(
      () => _i548.FakeAuthRepository(gh<_i489.FakeAuthBackend>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i862.PushService>(
      () => _i965.FakePushService(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i124.ProfileRepository>(
      () => _i214.FakeProfileRepository(gh<_i1059.RelationshipStore>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i42.CloseFriendsRepository>(
      () => _i1068.FakeCloseFriendsRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i1044.MessagingRepository>(
      () => _i900.FakeMessagingRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i603.CollectionsRepository>(
      () => _i617.FakeCollectionsRepository(),
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
    gh.lazySingleton<_i524.BlockRepository>(
      () => _i617.FakeBlockRepository(),
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
    gh.lazySingleton<_i550.DiscoveryRepository>(
      () => _i751.FakeDiscoveryRepository(gh<_i270.AppDatabase>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i323.FollowRequestsRepository>(
      () => _i426.FakeFollowRequestsRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i247.UserRepository>(
      () => _i156.FakeUserRepository(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i172.ReportRepository>(
      () => _i172.FakeReportRepository(),
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
    gh.lazySingleton<_i951.MessagingRealtimeService>(
      () => _i951.MessagingRealtimeService(
        gh<_i500.RealtimeClient>(),
        gh<_i270.AppDatabase>(),
        gh<_i433.AppLogger>(),
        gh<_i861.PresenceVisibility>(),
      ),
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
    gh.factory<_i297.PushPermissionCubit>(
      () => _i297.PushPermissionCubit(gh<_i862.PushService>()),
    );
    gh.lazySingleton<_i485.MeRepository>(
      () => _i211.FakeMeRepository(
        gh<_i489.FakeAuthBackend>(),
        gh<_i665.TokenStore>(),
      ),
      registerFor: {_fake},
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
    gh.lazySingleton<_i112.StoriesRepository>(
      () => _i840.StoriesRepositoryImpl(
        gh<_i270.AppDatabase>(),
        gh<_i784.ApiClient>(),
        gh<_i767.OwnStoryStore>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i547.MediaUploadService>(
      () => _i547.RealMediaUploadService(gh<_i784.ApiClient>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i1043.AuthRemoteDataSource>(
      () => _i1043.AuthRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i768.CollectionsRemoteDataSource>(
      () => _i768.CollectionsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i814.CommentsRemoteDataSource>(
      () => _i814.CommentsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i191.DiscoveryRemoteDataSource>(
      () => _i191.DiscoveryRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i138.FeedRemoteDataSource>(
      () => _i138.FeedRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i46.MeRemoteDataSource>(
      () => _i46.MeRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i962.MessagingRemoteDataSource>(
      () => _i962.MessagingRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i102.NotificationsRemoteDataSource>(
      () => _i102.NotificationsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i765.ProfileRemoteDataSource>(
      () => _i765.ProfileRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i746.ReelsRemoteDataSource>(
      () => _i746.ReelsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i710.SettingsRemoteDataSource>(
      () => _i710.SettingsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i625.FollowRequestsRemoteDataSource>(
      () => _i625.FollowRequestsRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i528.UserRemoteDataSource>(
      () => _i528.UserRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.factory<_i305.ChangeAvatar>(
      () => _i305.ChangeAvatar(gh<_i547.MediaUploadService>()),
    );
    gh.lazySingleton<_i485.MeRepository>(
      () => _i858.MeRepositoryImpl(
        gh<_i46.MeRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i124.ProfileRepository>(
      () => _i521.ProfileRepositoryImpl(
        gh<_i765.ProfileRemoteDataSource>(),
        gh<_i1059.RelationshipStore>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i42.CloseFriendsRepository>(
      () => _i753.CloseFriendsRepositoryImpl(gh<_i784.ApiClient>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i323.FollowRequestsRepository>(
      () => _i426.FollowRequestsRepositoryImpl(
        gh<_i625.FollowRequestsRemoteDataSource>(),
        gh<_i1059.RelationshipStore>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i1025.FollowRequestsCubit>(
      () => _i1025.FollowRequestsCubit(gh<_i323.FollowRequestsRepository>()),
    );
    gh.lazySingleton<_i524.BlockRepository>(
      () => _i221.BlockRepositoryImpl(gh<_i784.ApiClient>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i1030.CreatePostRepository>(
      () => _i794.RealCreatePostRepository(
        gh<_i784.ApiClient>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i1043.SettingsRepository>(
      () => _i996.SettingsRepositoryImpl(gh<_i710.SettingsRemoteDataSource>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i172.ReportRepository>(
      () => _i172.ReportRepositoryImpl(gh<_i784.ApiClient>()),
      registerFor: {_real},
    );
    gh.lazySingleton<_i550.DiscoveryRepository>(
      () => _i943.DiscoveryRepositoryImpl(
        gh<_i191.DiscoveryRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i674.CreateStoryRepository>(
      () => _i649.RealCreateStoryRepository(
        gh<_i547.MediaUploadService>(),
        gh<_i784.ApiClient>(),
        gh<_i767.OwnStoryStore>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i708.SettingsCubit>(
      () => _i708.SettingsCubit(
        gh<_i1043.SettingsRepository>(),
        gh<_i861.PresenceVisibility>(),
      ),
    );
    gh.lazySingleton<_i631.FollowAction>(
      () => _i631.FollowAction(
        gh<_i124.ProfileRepository>(),
        gh<_i1059.RelationshipStore>(),
      ),
    );
    gh.factory<_i465.CloseFriendsCubit>(
      () => _i465.CloseFriendsCubit(gh<_i42.CloseFriendsRepository>()),
    );
    gh.factory<_i305.LoadEditForm>(
      () => _i305.LoadEditForm(gh<_i485.MeRepository>()),
    );
    gh.factory<_i305.SaveProfile>(
      () => _i305.SaveProfile(gh<_i485.MeRepository>()),
    );
    gh.factory<_i983.WatchMe>(() => _i983.WatchMe(gh<_i485.MeRepository>()));
    gh.factory<_i983.FetchMe>(() => _i983.FetchMe(gh<_i485.MeRepository>()));
    gh.lazySingleton<_i111.BlockActions>(
      () => _i111.BlockActions(
        gh<_i524.BlockRepository>(),
        gh<_i1059.RelationshipStore>(),
        gh<_i18.BlockedUsersStore>(),
      ),
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
    gh.lazySingleton<_i552.CommentsRepository>(
      () => _i440.CommentsRepositoryImpl(gh<_i814.CommentsRemoteDataSource>()),
      registerFor: {_real},
    );
    gh.factory<_i287.PublishStory>(
      () => _i287.PublishStory(gh<_i674.CreateStoryRepository>()),
    );
    gh.factory<_i602.PublishPost>(
      () => _i602.PublishPost(
        gh<_i613.PhotoLibraryService>(),
        gh<_i12.ImageProcessingService>(),
        gh<_i547.MediaUploadService>(),
        gh<_i1030.CreatePostRepository>(),
      ),
    );
    gh.factory<_i531.LoadConnections>(
      () => _i531.LoadConnections(gh<_i124.ProfileRepository>()),
    );
    gh.factory<_i983.LoadProfile>(
      () => _i983.LoadProfile(gh<_i124.ProfileRepository>()),
    );
    gh.factory<_i983.LoadProfileGrid>(
      () => _i983.LoadProfileGrid(gh<_i124.ProfileRepository>()),
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
    gh.lazySingleton<_i342.NotificationsRepository>(
      () => _i832.NotificationsRepositoryImpl(
        gh<_i102.NotificationsRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i315.PushRegistrationService>(
      () => _i315.PushRegistrationService(
        gh<_i862.PushService>(),
        gh<_i342.NotificationsRepository>(),
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
    gh.factory<_i51.PublishReel>(
      () => _i51.PublishReel(
        gh<_i613.PhotoLibraryService>(),
        gh<_i547.MediaUploadService>(),
        gh<_i724.ReelsRepository>(),
      ),
    );
    gh.factory<_i895.MyProfileCubit>(
      () => _i895.MyProfileCubit(
        gh<_i983.WatchMe>(),
        gh<_i983.FetchMe>(),
        gh<_i983.LoadProfile>(),
        gh<_i983.LoadProfileGrid>(),
        gh<_i1059.RelationshipStore>(),
      ),
    );
    gh.factory<_i685.FollowBack>(
      () => _i685.FollowBack(gh<_i124.ProfileRepository>()),
    );
    gh.factory<_i263.ProfileCubit>(
      () => _i263.ProfileCubit(
        gh<_i983.LoadProfile>(),
        gh<_i983.LoadProfileGrid>(),
        gh<_i631.FollowAction>(),
        gh<_i1059.RelationshipStore>(),
      ),
    );
    gh.factory<_i762.ReelComposeCubit>(
      () => _i762.ReelComposeCubit(
        gh<_i613.PhotoLibraryService>(),
        gh<_i51.PublishReel>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i818.FollowListCubit>(
      () => _i818.FollowListCubit(
        gh<_i531.LoadConnections>(),
        gh<_i631.FollowAction>(),
        gh<_i1059.RelationshipStore>(),
      ),
    );
    gh.factory<_i547.BlockedAccountsCubit>(
      () => _i547.BlockedAccountsCubit(
        gh<_i524.BlockRepository>(),
        gh<_i111.BlockActions>(),
        gh<_i18.BlockedUsersStore>(),
      ),
    );
    gh.factory<_i321.WatchFeed>(
      () => _i321.WatchFeed(
        gh<_i850.FeedRepository>(),
        gh<_i18.BlockedUsersStore>(),
      ),
    );
    gh.factory<_i619.LoadHashtagPage>(
      () => _i619.LoadHashtagPage(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i619.LoadPlacePage>(
      () => _i619.LoadPlacePage(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i93.WatchExplore>(
      () => _i93.WatchExplore(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i93.LoadExploreFirst>(
      () => _i93.LoadExploreFirst(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i93.LoadExploreNext>(
      () => _i93.LoadExploreNext(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i488.GetRecents>(
      () => _i488.GetRecents(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i488.RecordRecent>(
      () => _i488.RecordRecent(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i488.DeleteRecent>(
      () => _i488.DeleteRecent(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i488.ClearRecents>(
      () => _i488.ClearRecents(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i96.SearchTopQuery>(
      () => _i96.SearchTopQuery(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i96.SearchAccounts>(
      () => _i96.SearchAccounts(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i96.SearchTags>(
      () => _i96.SearchTags(gh<_i550.DiscoveryRepository>()),
    );
    gh.factory<_i96.SearchPlaces>(
      () => _i96.SearchPlaces(gh<_i550.DiscoveryRepository>()),
    );
    gh.lazySingleton<_i776.NotificationsRealtimeService>(
      () => _i776.NotificationsRealtimeService(
        gh<_i500.RealtimeClient>(),
        gh<_i342.NotificationsRepository>(),
        gh<_i417.NotificationsBadge>(),
        gh<_i433.AppLogger>(),
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
    gh.factory<_i169.StoryViewerCubit>(
      () => _i169.StoryViewerCubit(
        gh<_i351.MarkSegmentSeen>(),
        gh<_i351.LikeStorySegment>(),
      ),
    );
    gh.factory<_i831.DiscoveryGridCubit>(
      () => _i831.DiscoveryGridCubit(
        gh<_i619.LoadHashtagPage>(),
        gh<_i619.LoadPlacePage>(),
      ),
    );
    gh.factory<_i433.StoryComposeCubit>(
      () => _i433.StoryComposeCubit(
        gh<_i287.PublishStory>(),
        gh<_i605.StoryImageComposer>(),
        gh<_i222.IdempotencyKeys>(),
      ),
    );
    gh.factory<_i685.WatchNotifications>(
      () => _i685.WatchNotifications(gh<_i342.NotificationsRepository>()),
    );
    gh.factory<_i685.LoadNotificationsPage>(
      () => _i685.LoadNotificationsPage(gh<_i342.NotificationsRepository>()),
    );
    gh.factory<_i685.RefreshNotifications>(
      () => _i685.RefreshNotifications(gh<_i342.NotificationsRepository>()),
    );
    gh.factory<_i685.MarkAllNotificationsRead>(
      () => _i685.MarkAllNotificationsRead(gh<_i342.NotificationsRepository>()),
    );
    gh.factory<_i685.FetchUnreadCount>(
      () => _i685.FetchUnreadCount(gh<_i342.NotificationsRepository>()),
    );
    gh.factory<_i270.StoriesRailCubit>(
      () => _i270.StoriesRailCubit(
        gh<_i351.LoadStoryReels>(),
        gh<_i351.WatchSeenSegments>(),
        gh<_i897.WatchOwnStoryChanges>(),
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
    gh.lazySingleton<_i603.CollectionsRepository>(
      () => _i776.CollectionsRepositoryImpl(
        gh<_i768.CollectionsRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
        gh<_i850.FeedRepository>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i812.RecentsCubit>(
      () => _i812.RecentsCubit(
        gh<_i488.GetRecents>(),
        gh<_i488.RecordRecent>(),
        gh<_i488.DeleteRecent>(),
        gh<_i488.ClearRecents>(),
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
    gh.factory<_i305.CheckUsername>(
      () => _i305.CheckUsername(gh<_i163.AuthRepository>()),
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
    gh.factory<_i391.EditProfileCubit>(
      () => _i391.EditProfileCubit(
        gh<_i305.LoadEditForm>(),
        gh<_i305.CheckUsername>(),
        gh<_i305.ChangeAvatar>(),
        gh<_i305.SaveProfile>(),
      ),
    );
    gh.factory<_i889.SearchCubit>(
      () => _i889.SearchCubit(
        gh<_i96.SearchTopQuery>(),
        gh<_i96.SearchAccounts>(),
        gh<_i96.SearchTags>(),
        gh<_i96.SearchPlaces>(),
      ),
    );
    gh.factory<_i569.ExploreCubit>(
      () => _i569.ExploreCubit(
        gh<_i93.WatchExplore>(),
        gh<_i93.LoadExploreFirst>(),
        gh<_i93.LoadExploreNext>(),
      ),
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
    gh.lazySingleton<_i35.RealtimeConnectionManager>(
      () => _i35.RealtimeConnectionManager(
        gh<_i500.RealtimeClient>(),
        gh<_i665.TokenStore>(),
        gh<_i951.MessagingRealtimeService>(),
        gh<_i776.NotificationsRealtimeService>(),
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
        gh<_i321.ToggleLike>(),
        gh<_i321.ToggleSave>(),
      ),
    );
    gh.factory<_i919.NotificationsCubit>(
      () => _i919.NotificationsCubit(
        gh<_i685.WatchNotifications>(),
        gh<_i685.LoadNotificationsPage>(),
        gh<_i685.RefreshNotifications>(),
        gh<_i685.MarkAllNotificationsRead>(),
        gh<_i685.FetchUnreadCount>(),
        gh<_i685.FollowBack>(),
        gh<_i417.NotificationsBadge>(),
      ),
    );
    gh.factory<_i706.LoadCollectionItems>(
      () => _i706.LoadCollectionItems(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i706.FullUnsave>(
      () => _i706.FullUnsave(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i1008.WatchCollections>(
      () => _i1008.WatchCollections(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i1008.LoadCollections>(
      () => _i1008.LoadCollections(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i416.CreateCollection>(
      () => _i416.CreateCollection(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i416.RenameCollection>(
      () => _i416.RenameCollection(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i416.DeleteCollection>(
      () => _i416.DeleteCollection(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i416.SetCollectionCover>(
      () => _i416.SetCollectionCover(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i451.LoadPicker>(
      () => _i451.LoadPicker(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i451.FileIntoCollection>(
      () => _i451.FileIntoCollection(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i451.UnfileFromCollection>(
      () => _i451.UnfileFromCollection(gh<_i603.CollectionsRepository>()),
    );
    gh.factory<_i1059.SaveToCollectionCubit>(
      () => _i1059.SaveToCollectionCubit(
        gh<_i451.LoadPicker>(),
        gh<_i451.FileIntoCollection>(),
        gh<_i451.UnfileFromCollection>(),
        gh<_i416.CreateCollection>(),
      ),
    );
    gh.factory<_i764.ForgotPasswordCubit>(
      () => _i764.ForgotPasswordCubit(
        gh<_i95.RequestPasswordReset>(),
        gh<_i894.ResetPassword>(),
      ),
    );
    gh.factory<_i556.CollectionsCubit>(
      () => _i556.CollectionsCubit(
        gh<_i1008.WatchCollections>(),
        gh<_i1008.LoadCollections>(),
      ),
    );
    gh.factory<_i192.CollectionDetailCubit>(
      () => _i192.CollectionDetailCubit(
        gh<_i706.LoadCollectionItems>(),
        gh<_i451.UnfileFromCollection>(),
        gh<_i706.FullUnsave>(),
      ),
    );
    gh.lazySingleton<_i958.SessionController>(
      () => _i958.SessionController(
        gh<_i665.TokenStore>(),
        gh<_i485.MeRepository>(),
        gh<_i299.LocalFlags>(),
        gh<_i270.AppDatabase>(),
        gh<_i767.OwnStoryStore>(),
        gh<_i1059.RelationshipStore>(),
        gh<_i35.RealtimeConnectionManager>(),
        gh<_i315.PushRegistrationService>(),
        gh<_i18.BlockedUsersStore>(),
        gh<_i242.AuthEventsSink>(),
      ),
    );
    gh.factory<_i142.CollectionEditCubit>(
      () => _i142.CollectionEditCubit(
        gh<_i416.CreateCollection>(),
        gh<_i416.RenameCollection>(),
        gh<_i416.DeleteCollection>(),
        gh<_i416.SetCollectionCover>(),
      ),
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
    gh.lazySingleton<_i1044.MessagingRepository>(
      () => _i948.MessagingRepositoryImpl(
        gh<_i962.MessagingRemoteDataSource>(),
        gh<_i270.AppDatabase>(),
        gh<_i500.RealtimeClient>(),
        gh<_i958.SessionController>(),
      ),
      registerFor: {_real},
    );
    gh.factory<_i973.WatchThread>(
      () => _i973.WatchThread(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.LoadHistory>(
      () => _i973.LoadHistory(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.SendText>(
      () => _i973.SendText(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.SendPhoto>(
      () => _i973.SendPhoto(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.SendSharedPost>(
      () => _i973.SendSharedPost(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.SendSticker>(
      () => _i973.SendSticker(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.RetrySend>(
      () => _i973.RetrySend(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.MarkRead>(
      () => _i973.MarkRead(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i973.EmitTyping>(
      () => _i973.EmitTyping(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i534.LoadConversations>(
      () => _i534.LoadConversations(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i587.SearchPeople>(
      () => _i587.SearchPeople(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i587.OpenOrStartConversation>(
      () => _i587.OpenOrStartConversation(gh<_i1044.MessagingRepository>()),
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
    gh.factory<_i902.OnboardingCubit>(
      () => _i902.OnboardingCubit(gh<_i958.SessionController>()),
    );
    gh.lazySingleton<_i485.AppRouter>(
      () => _i485.AppRouter(gh<_i958.SessionController>()),
    );
    gh.lazySingleton<_i779.MessagingLauncher>(
      () => _i297.MessagingLauncherImpl(gh<_i1044.MessagingRepository>()),
    );
    gh.factory<_i966.ChatCubit>(
      () => _i966.ChatCubit(
        gh<_i973.WatchThread>(),
        gh<_i973.LoadHistory>(),
        gh<_i973.SendText>(),
        gh<_i973.SendPhoto>(),
        gh<_i973.SendSharedPost>(),
        gh<_i973.SendSticker>(),
        gh<_i973.RetrySend>(),
        gh<_i973.MarkRead>(),
        gh<_i973.EmitTyping>(),
        gh<_i951.MessagingRealtimeService>(),
      ),
    );
    gh.factory<_i30.SignUpCubit>(() => _i30.SignUpCubit(gh<_i601.SignUp>()));
    gh.factory<_i534.WatchConversations>(
      () => _i534.WatchConversations(
        gh<_i1044.MessagingRepository>(),
        gh<_i18.BlockedUsersStore>(),
      ),
    );
    gh.factory<_i550.NewMessageCubit>(
      () => _i550.NewMessageCubit(
        gh<_i587.SearchPeople>(),
        gh<_i587.OpenOrStartConversation>(),
        gh<_i973.SendSharedPost>(),
      ),
    );
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
    gh.factory<_i385.ConversationsCubit>(
      () => _i385.ConversationsCubit(
        gh<_i534.WatchConversations>(),
        gh<_i534.LoadConversations>(),
        gh<_i951.MessagingRealtimeService>(),
      ),
    );
    gh.lazySingleton<_i1004.MessagingBadge>(
      () => _i1004.MessagingBadge(gh<_i1044.MessagingRepository>()),
    );
    return this;
  }
}
