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
import 'package:we36/core/data/me/fake_me_repository.dart' as _i211;
import 'package:we36/core/data/me/me_remote_data_source.dart' as _i46;
import 'package:we36/core/data/me/me_repository.dart' as _i485;
import 'package:we36/core/data/me/me_repository_impl.dart' as _i858;
import 'package:we36/core/data/realtime/fake_realtime_client.dart' as _i261;
import 'package:we36/core/data/realtime/realtime_client.dart' as _i500;
import 'package:we36/core/data/user/fake_user_repository.dart' as _i156;
import 'package:we36/core/data/user/user_remote_data_source.dart' as _i528;
import 'package:we36/core/data/user/user_repository.dart' as _i247;
import 'package:we36/core/data/user/user_repository_impl.dart' as _i514;
import 'package:we36/core/presentation/toast.dart' as _i857;
import 'package:we36/core/router/app_router.dart' as _i485;
import 'package:we36/core/services/session/auth_events.dart' as _i242;
import 'package:we36/core/services/session/local_flags.dart' as _i299;
import 'package:we36/core/services/session/real_token_refresher.dart' as _i266;
import 'package:we36/core/services/session/real_token_store.dart' as _i897;
import 'package:we36/core/services/session/session_controller.dart' as _i958;
import 'package:we36/core/services/session/token_refresher.dart' as _i200;
import 'package:we36/core/services/session/token_store.dart' as _i665;
import 'package:we36/core/utils/app_logger.dart' as _i433;

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
    gh.lazySingleton<_i857.ToastService>(() => _i857.ToastService());
    gh.lazySingleton<_i433.AppLogger>(() => const _i433.AppLogger());
    gh.lazySingleton<_i500.RealtimeClient>(
      () => _i500.SocketIoRealtimeClient(
        gh<_i434.AppConfig>(),
        gh<_i433.AppLogger>(),
      ),
      registerFor: {_real},
    );
    gh.lazySingleton<_i665.TokenStore>(() => _i897.RealTokenStore());
    gh.lazySingleton<_i299.LocalFlags>(() => _i299.LocalFlagsImpl());
    gh.lazySingleton<_i242.AuthEventsSink>(() => _i242.AuthEvents());
    gh.lazySingleton<_i489.FakeAuthBackend>(
      () => _i489.FakeAuthBackend(),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i163.AuthRepository>(
      () => _i548.FakeAuthRepository(gh<_i489.FakeAuthBackend>()),
      registerFor: {_fake},
    );
    gh.lazySingleton<_i200.TokenRefresher>(
      () => _i200.FakeTokenRefresher(),
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
    gh.lazySingleton<_i200.TokenRefresher>(
      () => _i266.RealTokenRefresher(
        gh<_i434.AppConfig>(),
        gh<_i665.TokenStore>(),
      ),
      registerFor: {_real},
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
    gh.lazySingleton<_i1043.AuthRemoteDataSource>(
      () => _i1043.AuthRemoteDataSource(gh<_i784.ApiClient>()),
    );
    gh.lazySingleton<_i46.MeRemoteDataSource>(
      () => _i46.MeRemoteDataSource(gh<_i784.ApiClient>()),
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
    gh.lazySingleton<_i958.SessionController>(
      () => _i958.SessionController(
        gh<_i665.TokenStore>(),
        gh<_i485.MeRepository>(),
        gh<_i299.LocalFlags>(),
        gh<_i270.AppDatabase>(),
        gh<_i242.AuthEventsSink>(),
      ),
    );
    gh.lazySingleton<_i485.AppRouter>(
      () => _i485.AppRouter(gh<_i958.SessionController>()),
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
    return this;
  }
}
