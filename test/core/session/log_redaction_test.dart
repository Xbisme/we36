import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Privacy guarantee (Constitution I; spec FR-014 / SC-008): credentials must
/// never reach the logs. The `AppLogger` redacts both free-form messages and
/// structured data before anything is written; this locks that behaviour for
/// the auth flow (access/refresh tokens, passwords, OTP, emails).
void main() {
  group('AppLogger.redact (free-form)', () {
    test('strips bearer access tokens', () {
      final out = AppLogger.redact('Authorization: Bearer eyJhbG.payload.sig');
      expect(out, contains('Bearer [redacted]'));
      expect(out, isNot(contains('eyJhbG')));
    });

    test('strips emails', () {
      final out = AppLogger.redact('login for demo@we36.app ok');
      expect(out, isNot(contains('demo@we36.app')));
      expect(out, contains('[redacted-email]'));
    });
  });

  group('AppLogger.redactMap (structured auth data)', () {
    test('redacts token / password / refresh / otp / email values', () {
      final safe = AppLogger.redactMap({
        'accessToken': 'eyJhbG.aaa',
        'refreshToken': 'opaque-refresh',
        'password': 'password123',
        'otp': '123456',
        'email': 'demo@we36.app',
        'username': 'demo', // not a secret → preserved
      });
      expect(safe['accessToken'], '[redacted]');
      expect(safe['refreshToken'], '[redacted]');
      expect(safe['password'], '[redacted]');
      expect(safe['otp'], '[redacted]');
      expect(safe['email'], '[redacted]');
      expect(safe['username'], 'demo');
    });

    test('no raw secret value survives redaction', () {
      final safe = AppLogger.redactMap({
        'authorization': 'Bearer secret-xyz',
        'newPassword': 'hunter2hunter2',
      });
      expect(safe.values, isNot(contains('Bearer secret-xyz')));
      expect(safe.values, isNot(contains('hunter2hunter2')));
    });
  });
}
