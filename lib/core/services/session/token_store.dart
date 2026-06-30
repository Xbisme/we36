import 'package:injectable/injectable.dart';

/// Read access to the current access token for the auth interceptor
/// (Constitution VIII). #002 owns only this *seam*; the real secure-storage
/// implementation lands with Auth #003.
abstract interface class TokenStore {
  /// The current access token, or null when signed out.
  String? get accessToken;
}

/// Default #002 implementation: an in-memory token holder. Replaced by the
/// secure-storage-backed store in #003. Keeps the app runnable with no backend.
@LazySingleton(as: TokenStore)
class FakeTokenStore implements TokenStore {
  /// Mutable current token (test/seed hook): assign to set or clear it.
  String? current;

  @override
  String? get accessToken => current;
}
