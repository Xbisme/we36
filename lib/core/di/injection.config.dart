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
import 'package:we36/core/presentation/toast.dart' as _i857;
import 'package:we36/core/router/app_router.dart' as _i485;
import 'package:we36/core/router/auth_guard_stub.dart' as _i53;
import 'package:we36/core/utils/app_logger.dart' as _i433;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i857.ToastService>(() => _i857.ToastService());
    gh.lazySingleton<_i53.AuthGuardStub>(() => _i53.AuthGuardStub());
    gh.lazySingleton<_i433.AppLogger>(() => const _i433.AppLogger());
    gh.lazySingleton<_i485.AppRouter>(
      () => _i485.AppRouter(gh<_i53.AuthGuardStub>()),
    );
    return this;
  }
}
