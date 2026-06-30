import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Request a password-reset OTP by email. Returns the dev-only `devCode` when the
/// backend surfaces it (dev flavor), else null — the response is uniform so it
/// never reveals whether the email has an account (spec FR-015).
@injectable
class RequestPasswordReset {
  const RequestPasswordReset(this._auth);

  final AuthRepository _auth;

  Future<Result<String?>> call(String email) =>
      _auth.requestPasswordReset(email: email);
}
