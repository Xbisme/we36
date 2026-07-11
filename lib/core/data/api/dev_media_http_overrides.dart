import 'dart:io';

import 'package:we36/core/data/api/dev_media_url.dart';

/// Dev-only `HttpOverrides` that rewrites `localhost`/`127.0.0.1` HTTP requests
/// to the LAN API host at the network layer. This is the single catch-all for
/// **every Dart-side image load** — `NetworkImage`, `CachedNetworkImage`,
/// avatars, thumbnails — whether the URL came fresh from the API or from the
/// drift cache, without touching any widget. Install in `bootstrap` for the dev
/// flavor only.
///
/// (Native `video_player` playback does NOT go through Dart's `HttpClient`, so
/// the reel player still rewrites its own URL — see `VideoReelPlayer`.)
class DevMediaHttpOverrides extends HttpOverrides {
  DevMediaHttpOverrides(this._apiHost);

  final String _apiHost;

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      _RewriteHttpClient(super.createHttpClient(context), _apiHost);
}

/// Forwards everything to [_inner], rewriting only the request URL so a benign
/// `localhost` media URL reaches the LAN host.
class _RewriteHttpClient implements HttpClient {
  _RewriteHttpClient(this._inner, this._apiHost);

  final HttpClient _inner;
  final String _apiHost;

  Uri _rewrite(Uri url) =>
      Uri.parse(rewriteLocalhostUrl(url.toString(), _apiHost));

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      _inner.openUrl(method, _rewrite(url));

  @override
  Future<HttpClientRequest> getUrl(Uri url) => _inner.getUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _inner.postUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _inner.putUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) =>
      _inner.deleteUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _inner.patchUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _inner.headUrl(_rewrite(url));

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) => _inner.open(method, host, port, path);

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _inner.get(host, port, path);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _inner.post(host, port, path);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _inner.put(host, port, path);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _inner.delete(host, port, path);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _inner.patch(host, port, path);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _inner.head(host, port, path);

  @override
  bool get autoUncompress => _inner.autoUncompress;
  @override
  set autoUncompress(bool value) => _inner.autoUncompress = value;

  @override
  Duration get idleTimeout => _inner.idleTimeout;
  @override
  set idleTimeout(Duration value) => _inner.idleTimeout = value;

  @override
  Duration? get connectionTimeout => _inner.connectionTimeout;
  @override
  set connectionTimeout(Duration? value) => _inner.connectionTimeout = value;

  @override
  int? get maxConnectionsPerHost => _inner.maxConnectionsPerHost;
  @override
  set maxConnectionsPerHost(int? value) => _inner.maxConnectionsPerHost = value;

  @override
  String? get userAgent => _inner.userAgent;
  @override
  set userAgent(String? value) => _inner.userAgent = value;

  @override
  set authenticate(
    Future<bool> Function(Uri url, String scheme, String? realm)? f,
  ) => _inner.authenticate = f;

  @override
  set authenticateProxy(
    Future<bool> Function(String host, int port, String scheme, String? realm)?
    f,
  ) => _inner.authenticateProxy = f;

  @override
  set badCertificateCallback(
    bool Function(X509Certificate cert, String host, int port)? callback,
  ) => _inner.badCertificateCallback = callback;

  @override
  set findProxy(String Function(Uri url)? f) => _inner.findProxy = f;

  @override
  set connectionFactory(
    Future<ConnectionTask<Socket>> Function(
      Uri url,
      String? proxyHost,
      int? proxyPort,
    )?
    f,
  ) => _inner.connectionFactory = f;

  @override
  set keyLog(void Function(String line)? callback) => _inner.keyLog = callback;

  @override
  void addCredentials(
    Uri url,
    String realm,
    HttpClientCredentials credentials,
  ) => _inner.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(
    String host,
    int port,
    String realm,
    HttpClientCredentials credentials,
  ) => _inner.addProxyCredentials(host, port, realm, credentials);

  @override
  void close({bool force = false}) => _inner.close(force: force);
}
