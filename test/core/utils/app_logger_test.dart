import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/utils/app_logger.dart';

void main() {
  group('AppLogger redaction (SC-010)', () {
    test('emails are redacted in free-form strings', () {
      expect(
        AppLogger.redact('contact me at qa.dtech@gmail.com please'),
        'contact me at [redacted-email] please',
      );
    });

    test('bearer tokens are redacted', () {
      expect(
        AppLogger.redact('Authorization: Bearer abc.def-123'),
        contains('Bearer [redacted]'),
      );
      expect(
        AppLogger.redact('Bearer abc.def-123'),
        isNot(contains('abc.def-123')),
      );
    });

    test('non-secret text is preserved', () {
      expect(AppLogger.redact('liked a post'), 'liked a post');
    });
  });
}
