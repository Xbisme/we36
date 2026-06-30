import 'package:injectable/injectable.dart';

/// Obtains a provider OIDC **id_token** on-device, to be exchanged with the
/// backend (`POST /v1/auth/oauth/{provider}`). A seam so the OAuth use cases are
/// testable without native plugins. Returns null when the user cancels the
/// provider sheet (→ silent no-op, spec FR-021).
abstract interface class OAuthTokenSource {
  Future<String?> googleIdToken();
  Future<String?> appleIdToken();
}

/// Fake source (`fake` env): returns dummy tokens so the OAuth flow runs end-to-
/// end with no network/native dependency (the fake backend ignores the token
/// value and links a synthetic account).
@LazySingleton(as: OAuthTokenSource, env: ['fake'])
class FakeOAuthTokenSource implements OAuthTokenSource {
  const FakeOAuthTokenSource();

  @override
  Future<String?> googleIdToken() async => 'fake-google-id-token';

  @override
  Future<String?> appleIdToken() async => 'fake-apple-id-token';
}
