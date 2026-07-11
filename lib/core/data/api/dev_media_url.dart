/// Dev-only media-URL rewriting shared by the API-response interceptor (fresh
/// data) and direct network consumers like the reel video player (which may read
/// a URL from the drift cache that predates the interceptor).
///
/// The backend derives media URLs from its `localhost` object store; on a
/// physical device `localhost` is the phone, so those URLs are unreachable.
/// Rewriting the host to the dev machine's LAN IP fixes it without a backend
/// change. No-op in production (URLs are `https://…`) and when [apiHost] is
/// empty/localhost.
String rewriteLocalhostUrl(String url, String? apiHost) {
  if (apiHost == null ||
      apiHost.isEmpty ||
      apiHost == 'localhost' ||
      apiHost == '127.0.0.1') {
    return url;
  }
  if (!url.startsWith('http://localhost') &&
      !url.startsWith('http://127.0.0.1')) {
    return url;
  }
  // NEVER rewrite a presigned (AWS SigV4) URL — the signature is bound to the
  // signed host, so changing the host would 403. Presigned upload/GET URLs must
  // be signed for a reachable host by the backend (S3_ENDPOINT), not rewritten
  // here. Only unsigned public delivery URLs (feed/avatar images) are rewritten.
  if (url.contains('X-Amz-Signature') || url.contains('X-Amz-Credential')) {
    return url;
  }
  final uri = Uri.tryParse(url);
  if (uri == null || (uri.host != 'localhost' && uri.host != '127.0.0.1')) {
    return url;
  }
  return uri.replace(host: apiHost).toString();
}

/// Holds the dev LAN API host for non-DI network consumers (the reel video
/// player factory is a top-level function). Set once at bootstrap in the dev
/// flavor; null in prod / tests → [rewriteLocalhostUrl] is a no-op.
abstract final class DevMediaHost {
  static String? host;
}
