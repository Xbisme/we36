import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/domain/result.dart';

/// Reference repository slice (Constitution V/VIII): returns `Result<T>`, never
/// throws. Real (`UserRepositoryImpl`, #002 US4) and fake (`FakeUserRepository`)
/// implementations are interchangeable via DI. Profile #010 extends this.
abstract interface class UserRepository {
  /// Fetch a public profile by username (cache-first + background refresh in the
  /// real impl; synthesized in the fake).
  Future<Result<User>> getByUsername(String username);

  /// Reactive read of the cached user (emits on updates; single canonical copy).
  Stream<User?> watchByUsername(String username);
}
