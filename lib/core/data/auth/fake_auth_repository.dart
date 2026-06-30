import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/data/auth/fake_auth_backend.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory [AuthRepository] (`fake` env): runs the full auth flow with no
/// backend, backed by the shared [FakeAuthBackend]. Demo account:
/// `demo@we36.app` / `password123`; fake reset OTP `123456`.
@LazySingleton(as: AuthRepository, env: ['fake'])
class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository(this._backend);

  final FakeAuthBackend _backend;

  @override
  Future<Result<Session>> register({
    required String email,
    required String password,
  }) async {
    final session = _backend.register(email, password);
    return session == null
        ? const Result.err(AppFailure.conflict())
        : Result.ok(session);
  }

  @override
  Future<Result<Session>> login({
    required String email,
    required String password,
  }) async {
    final session = _backend.login(email, password);
    return session == null
        ? const Result.err(AppFailure.invalidCredentials())
        : Result.ok(session);
  }

  @override
  Future<Result<Session>> oauth({
    required OAuthProvider provider,
    required String idToken,
  }) async => Result.ok(
    _backend.oauthLink('${provider.wire}@oauth.we36.local'),
  );

  @override
  Future<Result<void>> logout({required String refreshToken}) async =>
      const Result.ok(null);

  @override
  Future<Result<String?>> requestPasswordReset({required String email}) async =>
      const Result.ok(FakeAuthBackend.fakeOtp);

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final ok = _backend.resetPassword(email, code, newPassword);
    return ok
        ? const Result.ok(null)
        : const Result.err(
            AppFailure.validation(fields: {'code': 'invalid or expired'}),
          );
  }

  @override
  Future<Result<UsernameAvailability>> checkUsername({
    required String username,
  }) async {
    final r = _backend.checkUsername(username);
    return Result.ok(
      UsernameAvailability(
        available: r.available,
        reason: switch (r.reason) {
          'taken' => UsernameReason.taken,
          'invalid' => UsernameReason.invalid,
          _ => null,
        },
      ),
    );
  }
}
