import 'package:dio/dio.dart';
import 'package:we36/core/services/session/auth_events.dart';
import 'package:we36/core/services/session/token_refresher.dart';

/// `RequestOptions.extra` flag marking a request as already-retried (prevents a
/// refresh loop).
const String kRetriedFlag = 'we36.retried';

/// `RequestOptions.extra` flag marking the refresh call itself (never refreshed).
const String kIsRefreshFlag = 'we36.isRefresh';

/// Single-flight token refresh on `401 SESSION_EXPIRED` (Constitution VIII).
///
/// Concurrent 401s share ONE [TokenRefresher.refresh] (a shared in-flight future),
/// then each retries its original request once. If refresh fails, every waiter
/// resolves to the original 401 (mapped to `sessionExpired`) and exactly one
/// [AuthEventsSink.onUnauthenticated] fires. A plain (non-queued) interceptor is
/// used deliberately so concurrent errors overlap and dedupe on the shared future.
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required TokenRefresher refresher,
    required AuthEventsSink authEvents,
  }) : _refresher = refresher,
       _authEvents = authEvents;

  final TokenRefresher _refresher;
  final AuthEventsSink _authEvents;

  /// Re-fetches a request through the full interceptor chain (set by `ApiClient`
  /// to `dio.fetch`) so the retry re-attaches the refreshed token.
  late Future<Response<dynamic>> Function(RequestOptions options) retry;

  Future<bool>? _inFlight;
  bool _signalled = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    final refreshed = await _singleFlightRefresh();

    if (refreshed) {
      try {
        final options = err.requestOptions..extra[kRetriedFlag] = true;
        final response = await retry(options);
        handler.resolve(response);
      } on DioException catch (retryError) {
        handler.next(retryError);
      }
      return;
    }

    if (!_signalled) {
      _signalled = true;
      _authEvents.onUnauthenticated();
    }
    handler.next(err); // mapped to sessionExpired() by FailureMapper
  }

  Future<bool> _singleFlightRefresh() {
    final existing = _inFlight;
    if (existing != null) return existing;
    _signalled = false;
    final future = _refresher.refresh().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  bool _shouldRefresh(DioException err) {
    final options = err.requestOptions;
    if (options.extra[kRetriedFlag] == true) return false;
    if (options.extra[kIsRefreshFlag] == true) return false;
    if (err.response?.statusCode != 401) return false;
    return _code(err.response?.data) == 'SESSION_EXPIRED';
  }

  String? _code(dynamic data) {
    if (data is Map && data['error'] is Map) {
      final code = (data['error'] as Map)['code'];
      return code is String ? code : null;
    }
    return null;
  }
}
