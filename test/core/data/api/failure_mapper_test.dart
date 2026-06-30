import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/failure_mapper.dart';
import 'package:we36/core/domain/app_failure.dart';

void main() {
  const mapper = FailureMapper();
  final ro = RequestOptions(path: '/x');

  DioException badResponse(
    int status,
    Object? data, {
    Map<String, List<String>>? headers,
  }) => DioException(
    requestOptions: ro,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: ro,
      statusCode: status,
      data: data,
      headers: headers == null ? null : Headers.fromMap(headers),
    ),
  );

  Map<String, dynamic> envelope(String code, {Map<String, String>? details}) {
    final error = <String, dynamic>{'code': code, 'message': 'msg'};
    if (details != null) error['details'] = details;
    return {'error': error};
  }

  group('FailureMapper — error envelope codes (US1)', () {
    final cases = <String, AppFailure>{
      'UNAUTHENTICATED': const AppFailure.unauthenticated(),
      'INVALID_CREDENTIALS': const AppFailure.invalidCredentials(),
      'SESSION_EXPIRED': const AppFailure.sessionExpired(),
      'OAUTH_FAILED': const AppFailure.oauthFailed(),
      'FORBIDDEN': const AppFailure.forbidden(),
      'NOT_FOUND': const AppFailure.notFound(),
      'CONFLICT': const AppFailure.conflict(),
      'MEDIA_TOO_LARGE': const AppFailure.mediaTooLarge(),
      'UNSUPPORTED_MEDIA': const AppFailure.unsupportedMedia(),
      'UPLOAD_FAILED': const AppFailure.uploadFailed(),
      'SERVER_ERROR': const AppFailure.serverError(),
    };
    for (final entry in cases.entries) {
      test('${entry.key} → ${entry.value}', () {
        expect(
          mapper.fromDio(badResponse(400, envelope(entry.key))),
          entry.value,
        );
      });
    }

    test('VALIDATION carries the field details', () {
      final f = mapper.fromDio(
        badResponse(
          422,
          envelope('VALIDATION', details: {'username': 'taken'}),
        ),
      );
      expect(f, isA<AppFailureValidation>());
      expect((f as AppFailureValidation).fields, {'username': 'taken'});
    });

    test('RATE_LIMITED parses Retry-After seconds', () {
      final f = mapper.fromDio(
        badResponse(
          429,
          envelope('RATE_LIMITED'),
          headers: {
            'retry-after': ['30'],
          },
        ),
      );
      expect(f, isA<AppFailureRateLimited>());
      expect(
        (f as AppFailureRateLimited).retryAfter,
        const Duration(seconds: 30),
      );
    });

    test('unknown code preserves the message', () {
      final f = mapper.fromDio(badResponse(400, envelope('WEIRD_NEW_CODE')));
      expect(f, isA<AppFailureUnknown>());
      expect((f as AppFailureUnknown).message, 'msg');
    });
  });

  group('FailureMapper — transport faults (US1)', () {
    test('timeouts → timeout()', () {
      for (final t in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(
          mapper.fromDio(DioException(requestOptions: ro, type: t)),
          const AppFailure.timeout(),
        );
      }
    });

    test('connectionError → networkError() (offline inferred)', () {
      expect(
        mapper.fromDio(
          DioException(
            requestOptions: ro,
            type: DioExceptionType.connectionError,
          ),
        ),
        const AppFailure.networkError(),
      );
    });

    test('cancel → unknown(cancelled)', () {
      final f = mapper.fromDio(
        DioException(requestOptions: ro, type: DioExceptionType.cancel),
      );
      expect(f, const AppFailure.unknown(message: 'cancelled'));
    });
  });

  group('FailureMapper — malformed / status fallback (US1)', () {
    test('non-envelope 500 body → serverError()', () {
      expect(
        mapper.fromDio(badResponse(500, 'oops not json')),
        const AppFailure.serverError(),
      );
    });

    test('404 without envelope → notFound()', () {
      expect(
        mapper.fromDio(badResponse(404, null)),
        const AppFailure.notFound(),
      );
    });

    test('null response → unknown()', () {
      expect(
        mapper.fromDio(DioException(requestOptions: ro)),
        const AppFailure.unknown(),
      );
    });
  });
}
