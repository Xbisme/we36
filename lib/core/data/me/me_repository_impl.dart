import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/me_profile_dao.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_remote_data_source.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Real [MeRepository] (`real` env): reconciles the backend profile into the
/// drift cache, falls back to the cached copy on failure, and exposes a reactive
/// read so every screen observes one canonical profile (Constitution V/VIII/IX).
@LazySingleton(as: MeRepository, env: ['real'])
class MeRepositoryImpl implements MeRepository {
  MeRepositoryImpl(this._remote, this._db);

  final MeRemoteDataSource _remote;
  final AppDatabase _db;

  MeProfileDao get _dao => _db.meProfileDao;

  @override
  Future<Result<MeProfile>> getMe() async {
    final remote = await _remote.getMe();
    if (remote.isOk) {
      await _dao.upsert(remote.valueOrNull!);
      return remote;
    }
    final cached = await _dao.get();
    return cached != null
        ? Result<MeProfile>.ok(cached)
        : Result<MeProfile>.err(remote.failureOrNull!);
  }

  @override
  Stream<MeProfile?> watchMe() => _dao.watch();

  @override
  Future<Result<MeProfile>> setupProfile({
    required String username,
    required String displayName,
    String? bio,
  }) async {
    final remote = await _remote.setupProfile(
      username: username,
      displayName: displayName,
      bio: bio,
    );
    if (remote.isOk) await _dao.upsert(remote.valueOrNull!);
    return remote;
  }
}
