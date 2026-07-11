import 'package:dio/dio.dart';
import 'package:we36/core/data/api/dev_media_url.dart';

/// Dev-only: rewrites `http://localhost`/`http://127.0.0.1` URLs in every backend
/// response to the API host (the machine's LAN IP), preserving port + path.
///
/// The backend derives media delivery URLs from its own `localhost` object-store
/// endpoint. On the iOS Simulator `localhost` resolves to the dev machine, so
/// images load; on a **physical device** `localhost` is the phone itself →
/// "Connection refused". Rewriting the host here — one place, before any DTO is
/// decoded — makes every media/avatar/thumbnail URL reachable over the LAN
/// without touching the backend. No-op in production (prod URLs are `https://…`,
/// never `localhost`) and when the API host is itself localhost.
class DevMediaUrlInterceptor extends Interceptor {
  DevMediaUrlInterceptor(String apiHost) : _apiHost = apiHost;

  final String _apiHost;

  bool get _enabled =>
      _apiHost.isNotEmpty && _apiHost != 'localhost' && _apiHost != '127.0.0.1';

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_enabled) response.data = _walk(response.data);
    handler.next(response);
  }

  Object? _walk(Object? node) {
    if (node is String) return _rewrite(node);
    if (node is Map) {
      for (final key in node.keys.toList()) {
        node[key] = _walk(node[key]);
      }
      return node;
    }
    if (node is List) {
      for (var i = 0; i < node.length; i++) {
        node[i] = _walk(node[i]);
      }
      return node;
    }
    return node;
  }

  String _rewrite(String value) => rewriteLocalhostUrl(value, _apiHost);
}
