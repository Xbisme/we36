import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/features/auth/data/oauth_token_source.dart';

/// Google sign-in: obtain an id_token on-device, exchange it with the backend
/// (create-or-link), then start the session. A user cancel → `oauthCancelled`
/// (handled silently by the UI, spec FR-021).
@injectable
class SignInWithGoogle {
  const SignInWithGoogle(this._source, this._auth, this._session);

  final OAuthTokenSource _source;
  final AuthRepository _auth;
  final SessionController _session;

  Future<Result<MeProfile>> call() async {
    final idToken = await _source.googleIdToken();
    if (idToken == null) {
      return const Result<MeProfile>.err(AppFailure.oauthCancelled());
    }
    final result = await _auth.oauth(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
    if (result.isErr) return Result<MeProfile>.err(result.failureOrNull!);
    await _session.onAuthenticated(result.valueOrNull!);
    final me = _session.profile;
    return me != null
        ? Result<MeProfile>.ok(me)
        : const Result<MeProfile>.err(AppFailure.unknown());
  }
}
