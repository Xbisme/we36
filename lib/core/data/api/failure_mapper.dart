import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';

/// Centralized HTTP/transport → [AppFailure] mapping (Constitution V/VIII). The
/// backend error envelope is `{ error: { code, message, details? } }`; `code`
/// values are contract-stable. Call sites never inspect status codes.
@lazySingleton
class FailureMapper {
  const FailureMapper();

  /// Map a [DioException] to a typed [AppFailure].
  AppFailure fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const AppFailure.timeout();
      case DioExceptionType.connectionError:
        // No connectivity is inferred from the failed request (no connectivity service).
        return const AppFailure.networkError();
      case DioExceptionType.cancel:
        return const AppFailure.unknown(message: 'cancelled');
      case DioExceptionType.badCertificate:
        return const AppFailure.networkError();
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return _fromResponse(e.response);
    }
  }

  AppFailure _fromResponse(Response<dynamic>? response) {
    if (response == null) return const AppFailure.unknown();
    final code = _code(response.data);
    final message = _message(response.data);
    final details = _details(response.data);

    switch (code) {
      case 'UNAUTHENTICATED':
        return const AppFailure.unauthenticated();
      case 'INVALID_CREDENTIALS':
        return const AppFailure.invalidCredentials();
      case 'SESSION_EXPIRED':
        return const AppFailure.sessionExpired();
      case 'OAUTH_FAILED':
        return const AppFailure.oauthFailed();
      case 'FORBIDDEN':
        return const AppFailure.forbidden();
      case 'NOT_FOUND':
        return const AppFailure.notFound();
      case 'CONFLICT':
        return const AppFailure.conflict();
      case 'VALIDATION':
        return AppFailure.validation(fields: details ?? const {});
      case 'RATE_LIMITED':
        return AppFailure.rateLimited(retryAfter: _retryAfter(response));
      case 'MEDIA_TOO_LARGE':
        return const AppFailure.mediaTooLarge();
      case 'UNSUPPORTED_MEDIA':
        return const AppFailure.unsupportedMedia();
      case 'UPLOAD_FAILED':
        return const AppFailure.uploadFailed();
      case 'SERVER_ERROR':
        return const AppFailure.serverError();
    }

    // No / unknown envelope code → fall back on the HTTP status.
    final status = response.statusCode ?? 0;
    if (status == 429) {
      return AppFailure.rateLimited(retryAfter: _retryAfter(response));
    }
    if (status >= 500) return const AppFailure.serverError();
    if (status == 404) return const AppFailure.notFound();
    if (status == 403) return const AppFailure.forbidden();
    if (status == 401) return const AppFailure.unauthenticated();
    return AppFailure.unknown(message: message);
  }

  Map<String, dynamic>? _error(dynamic data) {
    if (data is Map && data['error'] is Map) {
      return (data['error'] as Map).cast<String, dynamic>();
    }
    return null;
  }

  String? _code(dynamic data) {
    final err = _error(data);
    final code = err?['code'];
    return code is String ? code : null;
  }

  String? _message(dynamic data) {
    final err = _error(data);
    final msg = err?['message'];
    return msg is String ? msg : null;
  }

  Map<String, String>? _details(dynamic data) {
    final err = _error(data);
    final details = err?['details'];
    if (details is Map) {
      return details.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return null;
  }

  Duration? _retryAfter(Response<dynamic> response) {
    final raw = response.headers.value('retry-after');
    if (raw == null) return null;
    final seconds = int.tryParse(raw.trim());
    return seconds == null ? null : Duration(seconds: seconds);
  }
}
