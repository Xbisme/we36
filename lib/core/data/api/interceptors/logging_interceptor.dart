import 'package:dio/dio.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Logs each request/response/error through [AppLogger] (Constitution I/IV):
/// never `print`, never secrets. Sensitive headers are redacted before logging.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  /// Header names whose values must never be logged.
  static const _sensitiveHeaders = <String>{
    'authorization',
    'cookie',
    'set-cookie',
    kIdempotencyHeaderLower,
  };

  static const String kIdempotencyHeaderLower = 'idempotency-key';

  /// Returns a copy of [headers] with sensitive values replaced by `[redacted]`.
  static Map<String, Object?> redactHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final redacted = _sensitiveHeaders.contains(key.toLowerCase());
      return MapEntry(key, redacted ? '[redacted]' : value);
    });
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug(
      '→ ${options.method} ${options.path}',
      data: {'headers': redactHeaders(options.headers)},
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      '← ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warn(
      '✗ ${err.response?.statusCode ?? '-'} ${err.requestOptions.path}',
      data: {'type': err.type.name},
    );
    handler.next(err);
  }
}
