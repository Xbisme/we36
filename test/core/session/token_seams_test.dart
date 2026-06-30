import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/config/app_config.dart';
import 'package:we36/core/services/session/real_token_refresher.dart';
import 'package:we36/core/services/session/real_token_store.dart';
import 'package:we36/core/services/session/token_store.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

class _MockDio extends Mock implements Dio {}

Response<dynamic> _resp(Object? data) => Response<dynamic>(
  requestOptions: RequestOptions(path: '/'),
  data: data,
);

void main() {
  group('RealTokenStore (secure-storage round-trip)', () {
    late _MockStorage storage;

    setUp(() {
      storage = _MockStorage();
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});
    });

    test('save persists both tokens + exposes them synchronously', () async {
      final store = RealTokenStore.withStorage(storage);
      await store.save(accessToken: 'acc', refreshToken: 'ref');
      expect(store.accessToken, 'acc');
      expect(store.refreshToken, 'ref');
      verify(
        () => storage.write(
          key: any(named: 'key'),
          value: 'acc',
        ),
      ).called(1);
      verify(
        () => storage.write(
          key: any(named: 'key'),
          value: 'ref',
        ),
      ).called(1);
    });

    test('hydrate loads persisted tokens into the mirror', () async {
      when(() => storage.read(key: any(named: 'key'))).thenAnswer(
        (inv) async => (inv.namedArguments[#key] as String).contains('access')
            ? 'acc'
            : 'ref',
      );
      final store = RealTokenStore.withStorage(storage);
      await store.hydrate();
      expect(store.accessToken, 'acc');
      expect(store.refreshToken, 'ref');
    });

    test('hydrate degrades to signed-out when storage throws', () async {
      when(
        () => storage.read(key: any(named: 'key')),
      ).thenThrow(Exception('no plugin'));
      final store = RealTokenStore.withStorage(storage);
      await store.hydrate();
      expect(store.accessToken, isNull);
    });

    test('clear erases both tokens', () async {
      final store = RealTokenStore.withStorage(storage);
      await store.save(accessToken: 'acc', refreshToken: 'ref');
      await store.clear();
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });
  });

  group('RealTokenRefresher', () {
    late _MockDio dio;
    late FakeTokenStore store;

    setUp(() {
      dio = _MockDio();
      store = FakeTokenStore();
    });

    test('no refresh token → false (no network call)', () async {
      final refresher = RealTokenRefresher.withDio(
        const AppConfig.dev(),
        store,
        dio,
      );
      expect(await refresher.refresh(), isFalse);
      verifyNever(() => dio.post<dynamic>(any(), data: any(named: 'data')));
    });

    test('200 → rotates tokens + true', () async {
      await store.save(accessToken: 'old', refreshToken: 'oldR');
      when(() => dio.post<dynamic>(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _resp({
          'accessToken': 'newA',
          'refreshToken': 'newR',
          'expiresIn': 900,
          'tokenType': 'Bearer',
        }),
      );
      final refresher = RealTokenRefresher.withDio(
        const AppConfig.dev(),
        store,
        dio,
      );
      expect(await refresher.refresh(), isTrue);
      expect(store.accessToken, 'newA');
      expect(store.refreshToken, 'newR');
    });

    test('network failure → false', () async {
      await store.save(accessToken: 'old', refreshToken: 'oldR');
      when(() => dio.post<dynamic>(any(), data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/')),
      );
      final refresher = RealTokenRefresher.withDio(
        const AppConfig.dev(),
        store,
        dio,
      );
      expect(await refresher.refresh(), isFalse);
    });
  });
}
