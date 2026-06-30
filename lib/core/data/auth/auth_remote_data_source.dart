import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/domain/result.dart';

/// Maps the auth endpoints to typed `Result`s via the shared [ApiClient]
/// (centralized HTTP→`AppFailure` mapping). Request bodies are explicit maps;
/// responses decode through generated `fromJson` (Constitution IV/VIII).
@lazySingleton
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<Session>> register(String email, String password) =>
      _api.post<Session>(
        ApiEndpoints.authRegister,
        body: {'email': email, 'password': password},
        decode: _decodeSession,
      );

  Future<Result<Session>> login(String email, String password) =>
      _api.post<Session>(
        ApiEndpoints.authLogin,
        body: {'email': email, 'password': password},
        decode: _decodeSession,
      );

  Future<Result<Session>> oauth(OAuthProvider provider, String idToken) =>
      _api.post<Session>(
        ApiEndpoints.authOauth(provider.wire),
        body: {'idToken': idToken},
        decode: _decodeSession,
      );

  Future<Result<void>> logout(String refreshToken) => _api.post<void>(
    ApiEndpoints.authLogout,
    body: {'refreshToken': refreshToken},
    decode: (_) {},
  );

  Future<Result<String?>> requestPasswordReset(String email) =>
      _api.post<String?>(
        ApiEndpoints.authForgot,
        body: {'email': email},
        decode: (data) {
          final code = data is Map ? data['devCode'] : null;
          return code is String ? code : null;
        },
      );

  Future<Result<void>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) => _api.post<void>(
    ApiEndpoints.authReset,
    body: {'email': email, 'code': code, 'newPassword': newPassword},
    decode: (_) {},
  );

  Future<Result<UsernameAvailability>> checkUsername(String username) =>
      _api.post<UsernameAvailability>(
        ApiEndpoints.authCheckUsername,
        body: {'username': username},
        decode: (data) => UsernameAvailability.fromJson(
          (data as Map).cast<String, dynamic>(),
        ),
      );

  static Session _decodeSession(dynamic data) =>
      Session.fromJson((data as Map).cast<String, dynamic>());
}
