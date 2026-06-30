import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Reset the password with a 6-digit OTP. On success the backend revokes all of
/// that account's existing sessions (spec FR-016); the user signs in fresh.
@injectable
class ResetPassword {
  const ResetPassword(this._auth);

  final AuthRepository _auth;

  Future<Result<void>> call({
    required String email,
    required String code,
    required String newPassword,
  }) => _auth.resetPassword(
    email: email,
    code: code,
    newPassword: newPassword,
  );
}
