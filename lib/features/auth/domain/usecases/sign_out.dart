import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/core/services/session/token_store.dart';

/// Sign out: best-effort server revoke of the refresh token, then clear the
/// local session + wipe all user-scoped cache (Constitution I; spec FR-013).
/// Completes locally even when the network call fails or the device is offline.
@injectable
class SignOut {
  const SignOut(this._auth, this._tokenStore, this._session);

  final AuthRepository _auth;
  final TokenStore _tokenStore;
  final SessionController _session;

  Future<void> call() async {
    final refreshToken = _tokenStore.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _auth.logout(
        refreshToken: refreshToken,
      ); // best-effort; ignore result
    }
    await _session.signOut();
  }
}
