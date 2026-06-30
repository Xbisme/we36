import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/session_controller.dart';

/// Email + password sign-in: exchange credentials for a session, then hand it to
/// the [SessionController] (persist tokens, load the profile, flip auth state →
/// the router redirects). Returns the loaded profile (Constitution V/VIII).
@injectable
class SignIn {
  const SignIn(this._auth, this._session);

  final AuthRepository _auth;
  final SessionController _session;

  Future<Result<MeProfile>> call(String email, String password) async {
    final result = await _auth.login(email: email, password: password);
    if (result.isErr) return Result<MeProfile>.err(result.failureOrNull!);
    await _session.onAuthenticated(result.valueOrNull!);
    final me = _session.profile;
    return me != null
        ? Result<MeProfile>.ok(me)
        : const Result<MeProfile>.err(AppFailure.unknown());
  }
}
