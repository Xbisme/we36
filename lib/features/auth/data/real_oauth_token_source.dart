import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:we36/features/auth/data/oauth_token_source.dart';

/// Real [OAuthTokenSource] (`real` env): obtains the provider id_token via the
/// native Google / Apple sheets. A user cancel returns null (silent no-op, spec
/// FR-021); other provider failures rethrow → mapped to `oauthFailed`.
@LazySingleton(as: OAuthTokenSource, env: ['real'])
class RealOAuthTokenSource implements OAuthTokenSource {
  RealOAuthTokenSource();

  bool _googleReady = false;

  Future<void> _ensureGoogle() async {
    if (_googleReady) return;
    // Client IDs come from native config (Info.plist / strings); see T063.
    await GoogleSignIn.instance.initialize();
    _googleReady = true;
  }

  @override
  Future<String?> googleIdToken() async {
    try {
      await _ensureGoogle();
      final account = await GoogleSignIn.instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<String?> appleIdToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [AppleIDAuthorizationScopes.email],
      );
      return credential.identityToken;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }
}
