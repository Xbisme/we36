import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/data/user/user_remote_data_source.dart';
import 'package:we36/core/data/user/user_repository_impl.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Stub remote source (implements the public surface; the private Dio seam is
/// irrelevant to the interface).
class _StubRemote implements UserRemoteDataSource {
  _StubRemote(this.result);
  Result<User> result;
  int calls = 0;

  @override
  Future<Result<User>> getByUsername(String username) async {
    calls++;
    return result;
  }
}

User _user(String username) => User(
  id: 'id-$username',
  username: username,
  displayName: username,
  isPrivate: false,
  isVerified: false,
  followersCount: 3,
  followingCount: 1,
  postsCount: 0,
);

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('UserRepositoryImpl (US4 / SC-007)', () {
    test('remote success → upserts cache + returns user', () async {
      final remote = _StubRemote(Result.ok(_user('maivu')));
      final repo = UserRepositoryImpl(remote, db);

      final result = await repo.getByUsername('maivu');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.username, 'maivu');
      expect(await db.usersDao.getByUsername('maivu'), isNotNull); // cached
    });

    test('remote failure with a cached value → returns cached', () async {
      await db.usersDao.upsert(_user('lan'));
      final repo = UserRepositoryImpl(
        _StubRemote(const Result.err(AppFailure.networkError())),
        db,
      );

      final result = await repo.getByUsername('lan');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.username, 'lan');
    });

    test('remote failure with no cache → returns the failure', () async {
      final repo = UserRepositoryImpl(
        _StubRemote(const Result.err(AppFailure.serverError())),
        db,
      );

      final result = await repo.getByUsername('ghost');

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, const AppFailure.serverError());
    });

    test('watchByUsername reflects cache writes', () async {
      final repo = UserRepositoryImpl(_StubRemote(Result.ok(_user('huy'))), db);
      final seen = <User?>[];
      final sub = repo.watchByUsername('huy').listen(seen.add);

      await repo.getByUsername('huy');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(seen.whereType<User>().map((u) => u.username), contains('huy'));
      await sub.cancel();
    });
  });
}
