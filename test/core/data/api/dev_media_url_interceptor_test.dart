import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/interceptors/dev_media_url_interceptor.dart';

Response<dynamic> _through(DevMediaUrlInterceptor i, dynamic data) {
  final response = Response<dynamic>(
    requestOptions: RequestOptions(path: '/x'),
    data: data,
  );
  i.onResponse(response, ResponseInterceptorHandler());
  return response;
}

void main() {
  group('DevMediaUrlInterceptor (localhost → LAN host)', () {
    final i = DevMediaUrlInterceptor('192.168.1.137');

    test('rewrites host but keeps port + path + query', () {
      final r = _through(i, {
        'url': 'http://localhost:9000/we36-media/media/a/b.webp?x=1',
      });
      expect(
        (r.data as Map)['url'],
        'http://192.168.1.137:9000/we36-media/media/a/b.webp?x=1',
      );
    });

    test('rewrites deeply nested strings in maps + lists', () {
      final r = _through(i, {
        'items': [
          {
            'media': [
              {'url': 'http://127.0.0.1:9000/we36-media/x.webp'},
            ],
            'author': {'avatarUrl': 'http://localhost:9000/a/av.jpg'},
          },
        ],
      });
      final item = ((r.data as Map)['items'] as List).first as Map;
      final media = (item['media'] as List).first as Map;
      expect(media['url'], 'http://192.168.1.137:9000/we36-media/x.webp');
      expect(
        (item['author'] as Map)['avatarUrl'],
        'http://192.168.1.137:9000/a/av.jpg',
      );
    });

    test('does NOT rewrite a presigned (signed) upload URL', () {
      final r = _through(i, {
        'uploadUrl':
            'http://localhost:9000/we36-media/x?X-Amz-Signature=abc&X-Amz-Credential=k',
      });
      // Signature is host-bound → must be left as-signed (backend signs for LAN).
      expect(
        (r.data as Map)['uploadUrl'],
        'http://localhost:9000/we36-media/x?X-Amz-Signature=abc&X-Amz-Credential=k',
      );
    });

    test('leaves non-localhost + non-URL strings untouched', () {
      final r = _through(i, {
        'cdn': 'https://cdn.we36.app/x.webp',
        'name': 'localhost is my nickname',
      });
      expect((r.data as Map)['cdn'], 'https://cdn.we36.app/x.webp');
      expect((r.data as Map)['name'], 'localhost is my nickname');
    });

    test('no-op when the API host is itself localhost', () {
      final noop = DevMediaUrlInterceptor('localhost');
      final r = _through(noop, {'url': 'http://localhost:9000/x.webp'});
      expect((r.data as Map)['url'], 'http://localhost:9000/x.webp');
    });
  });
}
