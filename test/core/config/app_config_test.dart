import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/config/app_config.dart';

void main() {
  group('AppConfig per-flavor endpoints (US6)', () {
    test('dev and prod resolve distinct API + realtime endpoints', () {
      const dev = AppConfig.dev();
      const prod = AppConfig.prod();

      expect(dev.apiBaseUrl, isNot(prod.apiBaseUrl));
      expect(dev.realtimeUrl, isNot(prod.realtimeUrl));
      expect(dev.isDev, isTrue);
      expect(prod.isDev, isFalse);
    });

    test('API base URLs are rooted at /v1', () {
      expect(const AppConfig.dev().apiBaseUrl, endsWith('/v1'));
      expect(const AppConfig.prod().apiBaseUrl, endsWith('/v1'));
    });
  });
}
