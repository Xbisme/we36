import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/domain/result.dart';

/// External identity provider for OAuth sign-in. The wire value is the path
/// segment of `POST /v1/auth/oauth/{provider}`.
enum OAuthProvider {
  google,
  apple;

  String get wire => name;
}

/// Credential operations over the backend auth contract (Constitution V/VIII):
/// every method returns `Result<T>` and never throws. Real + in-memory fake
/// implementations are interchangeable via DI. Token *persistence* is the
/// session layer's job (use cases call `TokenStore`); this repo is pure network.
/// Token *refresh* is owned by `RealTokenRefresher`, not exposed here.
abstract interface class AuthRepository {
  Future<Result<Session>> register({
    required String email,
    required String password,
  });

  Future<Result<Session>> login({
    required String email,
    required String password,
  });

  Future<Result<Session>> oauth({
    required OAuthProvider provider,
    required String idToken,
  });

  /// Best-effort revoke of the presented refresh token (204 idempotent).
  Future<Result<void>> logout({required String refreshToken});

  /// Request a password-reset OTP. Returns the dev-only `devCode` when the
  /// backend surfaces it (dev flavor), else null — never assume a channel.
  Future<Result<String?>> requestPasswordReset({required String email});

  Future<Result<void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<Result<UsernameAvailability>> checkUsername({
    required String username,
  });
}
