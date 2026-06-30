import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/interceptors/logging_interceptor.dart';
import 'package:we36/core/utils/app_logger.dart';

void main() {
  group('Redacting logging (US1 / SC-008)', () {
    test('redactHeaders hides Authorization / Cookie / Idempotency-Key', () {
      final safe = LoggingInterceptor.redactHeaders({
        'Authorization': 'Bearer super-secret-token',
        'Cookie': 'session=abc',
        'Idempotency-Key': 'uuid-123',
        'Accept': 'application/json',
      });
      expect(safe['Authorization'], '[redacted]');
      expect(safe['Cookie'], '[redacted]');
      expect(safe['Idempotency-Key'], '[redacted]');
      expect(safe['Accept'], 'application/json'); // non-sensitive kept
    });

    test('redaction is case-insensitive on header name', () {
      final safe = LoggingInterceptor.redactHeaders({
        'authorization': 'Bearer x',
      });
      expect(safe['authorization'], '[redacted]');
    });

    test('AppLogger.redact scrubs bearer tokens and emails in free text', () {
      expect(
        AppLogger.redact('token Bearer abc.def-123'),
        contains('Bearer [redacted]'),
      );
      expect(
        AppLogger.redact('user a@b.com signed in'),
        contains('[redacted-email]'),
      );
    });
  });
}
