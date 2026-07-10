import 'package:injectable/injectable.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/data/settings/settings_remote_data_source.dart';
import 'package:we36/core/data/settings/settings_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Live account settings over the backend (#014, B#014).
@LazySingleton(as: SettingsRepository, env: ['real'])
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._remote);

  final SettingsRemoteDataSource _remote;

  @override
  Future<Result<AccountSettings>> getSettings() => _remote.getSettings();

  @override
  Future<Result<AccountSettings>> setPrivate({required bool isPrivate}) =>
      _remote.patch({'isPrivate': isPrivate});

  @override
  Future<Result<AccountSettings>> setActivityStatus({required bool visible}) =>
      _remote.patch({'activityStatusVisible': visible});
}
