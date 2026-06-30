import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/services/session/token_refresher.dart';
import 'package:we36/core/services/session/token_store.dart';

/// The real single-flight refresh worker (`real` env). Deliberately uses a
/// **bare** [Dio] (no interceptors) and the absolute refresh URL, so it never
/// re-enters the auth/refresh interceptor chain that drives it — avoiding both a
/// circular dependency on `ApiClient` and a refresh-of-a-refresh loop
/// (Constitution VIII). The interceptor's single-flight wrapper still guarantees
/// at most one concurrent call.
@LazySingleton(as: TokenRefresher, env: ['real'])
class RealTokenRefresher implements TokenRefresher {
  RealTokenRefresher(this._config, this._tokenStore) : _dio = Dio();

  /// Testing seam: inject a stubbed [Dio].
  @visibleForTesting
  RealTokenRefresher.withDio(this._config, this._tokenStore, this._dio);

  final AppConfig _config;
  final TokenStore _tokenStore;
  final Dio _dio;

  @override
  Future<bool> refresh() async {
    final refreshToken = _tokenStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final response = await _dio.post<dynamic>(
        '${_config.apiBaseUrl}${ApiEndpoints.authRefresh}',
        data: {'refreshToken': refreshToken},
      );
      final session = Session.fromJson(
        (response.data as Map).cast<String, dynamic>(),
      );
      await _tokenStore.save(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      return true;
    } on Object {
      // Refresh failed (expired / revoked / network): the interceptor surfaces
      // `sessionExpired` + the unauthenticated signal exactly once.
      return false;
    }
  }
}
