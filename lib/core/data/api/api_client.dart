import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/data/api/failure_mapper.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/api/interceptors/auth_token_interceptor.dart';
import 'package:we36/core/data/api/interceptors/logging_interceptor.dart';
import 'package:we36/core/data/api/interceptors/refresh_interceptor.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/auth_events.dart';
import 'package:we36/core/services/session/token_refresher.dart';
import 'package:we36/core/services/session/token_store.dart';
import 'package:we36/core/utils/app_logger.dart';

/// The single REST entry point (Constitution VIII): one [Dio] behind the auth /
/// refresh / idempotency / logging interceptors, exposing `Result`-returning
/// methods. Repositories use this; widgets/cubits never touch HTTP directly.
@lazySingleton
class ApiClient {
  /// Production: builds and owns its own [Dio].
  ApiClient(
    AppConfig config,
    TokenStore tokenStore,
    TokenRefresher refresher,
    AuthEventsSink authEvents,
    AppLogger logger,
    FailureMapper mapper,
    IdempotencyKeys idempotencyKeys,
  ) : this._(
        Dio(),
        config,
        tokenStore,
        refresher,
        authEvents,
        logger,
        mapper,
        idempotencyKeys,
      );

  /// Testing seam: inject a pre-built [Dio] (e.g. with a stub adapter).
  @visibleForTesting
  ApiClient.withDio(
    Dio dio,
    AppConfig config,
    TokenStore tokenStore,
    TokenRefresher refresher,
    AuthEventsSink authEvents,
    AppLogger logger,
    FailureMapper mapper,
    IdempotencyKeys idempotencyKeys,
  ) : this._(
        dio,
        config,
        tokenStore,
        refresher,
        authEvents,
        logger,
        mapper,
        idempotencyKeys,
      );

  ApiClient._(
    this._dio,
    AppConfig config,
    TokenStore tokenStore,
    TokenRefresher refresher,
    AuthEventsSink authEvents,
    AppLogger logger,
    this._mapper,
    IdempotencyKeys idempotencyKeys,
  ) {
    _dio.options = _dio.options.copyWith(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    );
    final refresh = RefreshInterceptor(
      refresher: refresher,
      authEvents: authEvents,
    )..retry = _dio.fetch;
    _dio.interceptors.addAll([
      IdempotencyInterceptor(idempotencyKeys),
      AuthTokenInterceptor(tokenStore),
      refresh,
      LoggingInterceptor(logger),
    ]);
  }

  final Dio _dio;
  final FailureMapper _mapper;

  /// GET → decoded `T` (via [decode]) or a typed failure.
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic data)? decode,
  }) => _request(() => _dio.get<dynamic>(path, queryParameters: query), decode);

  /// POST → decoded `T`. Pass [idempotent] = true for content-creating mutations.
  /// Pass an explicit [idempotencyKey] (e.g. a draft's stable key) to reuse the
  /// same `Idempotency-Key` header across retries so exactly one entity is
  /// created (FR-020); otherwise the interceptor generates a per-request key.
  Future<Result<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(dynamic data)? decode,
    bool idempotent = false,
    String? idempotencyKey,
  }) => _request(
    () => _dio.post<dynamic>(
      path,
      data: body,
      queryParameters: query,
      options: (idempotent || idempotencyKey != null)
          ? Options(
              extra: const {kIdempotentFlag: true},
              headers: idempotencyKey != null
                  ? {kIdempotencyHeader: idempotencyKey}
                  : null,
            )
          : null,
    ),
    decode,
  );

  /// PATCH → decoded `T`. Partial update of a resource (e.g. `PATCH /me`, #010);
  /// naturally idempotent (last-write-wins on the sent fields).
  Future<Result<T>> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(dynamic data)? decode,
  }) => _request(
    () => _dio.patch<dynamic>(path, data: body, queryParameters: query),
    decode,
  );

  /// DELETE → decoded `T`. Used by idempotent remove-toggles (unlike/unsave,
  /// #004; unfollow/unsave-collection later).
  Future<Result<T>> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(dynamic data)? decode,
  }) => _request(
    () => _dio.delete<dynamic>(path, data: body, queryParameters: query),
    decode,
  );

  Future<Result<T>> _request<T>(
    Future<Response<dynamic>> Function() send,
    T Function(dynamic data)? decode,
  ) async {
    try {
      final response = await send();
      final data = decode != null ? decode(response.data) : response.data as T;
      return Result<T>.ok(data);
    } on DioException catch (e) {
      return Result<T>.err(_mapper.fromDio(e));
    } on Object catch (e) {
      return Result<T>.err(AppFailure.unknown(error: e));
    }
  }
}
