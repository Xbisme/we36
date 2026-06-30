import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/users_dao.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/data/user/user_remote_data_source.dart';
import 'package:we36/core/data/user/user_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Real reference-slice repository: remote fetch reconciled into the drift cache,
/// with reactive reads and cache-fallback on failure (Constitution V/VIII/IX).
/// Registered only in the `real` environment, so the in-memory `FakeUserRepository`
/// stays the default while #002 runs without a backend.
@LazySingleton(as: UserRepository, env: ['real'])
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remote, this._db);

  final UserRemoteDataSource _remote;
  final AppDatabase _db;

  UsersDao get _dao => _db.usersDao;

  @override
  Future<Result<User>> getByUsername(String username) async {
    final remote = await _remote.getByUsername(username);
    if (remote.isOk) {
      final user = remote.valueOrNull!;
      await _dao.upsert(user);
      return Result<User>.ok(user);
    }
    // Remote failed — fall back to the cached value if present.
    final cached = await _dao.getByUsername(username);
    return cached != null
        ? Result<User>.ok(cached)
        : Result<User>.err(remote.failureOrNull!);
  }

  @override
  Stream<User?> watchByUsername(String username) =>
      _dao.watchByUsername(username);
}
