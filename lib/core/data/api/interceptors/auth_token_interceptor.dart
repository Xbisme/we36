import 'package:dio/dio.dart';
import 'package:we36/core/services/session/token_store.dart';

/// Attaches `Authorization: Bearer <accessToken>` to outgoing requests from the
/// current [TokenStore] (Constitution VIII). Runs on every request, including the
/// post-refresh retry, so the retry carries the freshly refreshed token.
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor(this._tokenStore);

  final TokenStore _tokenStore;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStore.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
