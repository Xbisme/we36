import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// Header carrying the client-generated idempotency key (Constitution IX).
const String kIdempotencyHeader = 'Idempotency-Key';

/// `RequestOptions.extra` flag marking a content-creating mutation as idempotent.
const String kIdempotentFlag = 'we36.idempotent';

/// Generates UUIDv7 idempotency keys (matches the backend id scheme).
@lazySingleton
class IdempotencyKeys {
  IdempotencyKeys() : _uuid = const Uuid();

  final Uuid _uuid;

  String generate() => _uuid.v7();
}

/// Builds [Options] that mark a request idempotent so [IdempotencyInterceptor]
/// attaches (and reuses across the single post-refresh retry) a stable key.
Options idempotent([Options? base]) {
  final options = base ?? Options();
  return options.copyWith(extra: {...?options.extra, kIdempotentFlag: true});
}

/// Attaches an `Idempotency-Key` to flagged requests when one is not already
/// present. Because dio reuses the same [RequestOptions] on the post-refresh
/// retry, the key is generated once and reused (retry-safe).
class IdempotencyInterceptor extends Interceptor {
  IdempotencyInterceptor(this._keys);

  final IdempotencyKeys _keys;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final flagged = options.extra[kIdempotentFlag] == true;
    if (flagged && !options.headers.containsKey(kIdempotencyHeader)) {
      options.headers[kIdempotencyHeader] = _keys.generate();
    }
    handler.next(options);
  }
}
