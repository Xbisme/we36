import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/interceptors/auth_token_interceptor.dart';
import 'package:we36/core/data/api/interceptors/refresh_interceptor.dart';
import 'package:we36/core/services/session/auth_events.dart';
import 'package:we36/core/services/session/token_refresher.dart';
import 'package:we36/core/services/session/token_store.dart';

/// Stub adapter: a request that has NOT been retried gets `401 SESSION_EXPIRED`;
/// the post-refresh retry (carrying [kRetriedFlag]) gets `200`.
class _StubAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    final retried = options.extra[kRetriedFlag] == true;
    if (retried) {
      return ResponseBody.fromString(
        jsonEncode({'ok': true}),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode({
        'error': {'code': 'SESSION_EXPIRED', 'message': 'expired'},
      }),
      401,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _buildDio(
  _StubAdapter adapter,
  TokenStore store,
  TokenRefresher refresher,
  AuthEventsSink authEvents,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter;
  final refresh = RefreshInterceptor(
    refresher: refresher,
    authEvents: authEvents,
  )..retry = dio.fetch;
  dio.interceptors.addAll([AuthTokenInterceptor(store), refresh]);
  return dio;
}

void main() {
  group('Single-flight refresh (US1 / SC-002)', () {
    test(
      'N concurrent 401s trigger exactly ONE refresh, then all retry & succeed',
      () async {
        final adapter = _StubAdapter();
        final store = FakeTokenStore()..current = 'old-token';
        final refresher = FakeTokenRefresher()
          ..succeeds = true
          // Widen the window so all N requests share one in-flight refresh.
          ..beforeReturn = (() =>
              Future<void>.delayed(const Duration(milliseconds: 50)));
        final authEvents = AuthEvents();
        final dio = _buildDio(adapter, store, refresher, authEvents);

        final responses = await Future.wait([
          for (var i = 0; i < 5; i++) dio.get<dynamic>('/me'),
        ]);

        expect(
          refresher.calls,
          1,
          reason: 'single-flight: one refresh for N 401s',
        );
        expect(responses.every((r) => r.statusCode == 200), isTrue);
        expect(authEvents.signalCount, 0);
        authEvents.dispose();
      },
    );

    test(
      'refresh failure → sessionExpired + exactly one unauthenticated signal',
      () async {
        final adapter = _StubAdapter();
        final store = FakeTokenStore()..current = 'old-token';
        final refresher = FakeTokenRefresher()
          ..succeeds = false
          ..beforeReturn = (() =>
              Future<void>.delayed(const Duration(milliseconds: 50)));
        final authEvents = AuthEvents();
        final dio = _buildDio(adapter, store, refresher, authEvents);

        final results = await Future.wait([
          for (var i = 0; i < 4; i++)
            dio
                .get<dynamic>('/me')
                .then<int?>((r) => r.statusCode)
                .catchError(
                  (Object e) => (e as DioException).response?.statusCode,
                ),
        ]);

        expect(refresher.calls, 1);
        expect(results.every((s) => s == 401), isTrue);
        expect(
          authEvents.signalCount,
          1,
          reason: 'one logout signal for N failures',
        );
        authEvents.dispose();
      },
    );
  });
}
