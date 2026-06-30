import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_remote_data_source.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/domain/result.dart';

/// Real [AuthRepository] (`real` env): a thin pass-through to the remote source
/// (the API client owns error mapping). Token persistence + session state are
/// handled by the session layer, not here (Constitution VIII).
@LazySingleton(as: AuthRepository, env: ['real'])
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Result<Session>> register({
    required String email,
    required String password,
  }) => _remote.register(email, password);

  @override
  Future<Result<Session>> login({
    required String email,
    required String password,
  }) => _remote.login(email, password);

  @override
  Future<Result<Session>> oauth({
    required OAuthProvider provider,
    required String idToken,
  }) => _remote.oauth(provider, idToken);

  @override
  Future<Result<void>> logout({required String refreshToken}) =>
      _remote.logout(refreshToken);

  @override
  Future<Result<String?>> requestPasswordReset({required String email}) =>
      _remote.requestPasswordReset(email);

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _remote.resetPassword(email, code, newPassword);

  @override
  Future<Result<UsernameAvailability>> checkUsername({
    required String username,
  }) => _remote.checkUsername(username);
}
