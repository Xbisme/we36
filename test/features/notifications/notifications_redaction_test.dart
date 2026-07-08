import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/utils/app_logger.dart';

/// #013 US6 T052: push tokens + private content never reach the logs
/// (Constitution I; FR-023 / SC-007).
void main() {
  test('device push token keys are redacted by the logger', () {
    final safe = AppLogger.redactMap({
      'platform': 'ios',
      'token': 'secret-fcm-apns-token',
      'deviceToken': 'another-secret',
    });
    expect(safe['token'], '[redacted]');
    expect(safe['deviceToken'], '[redacted]');
    expect(safe['platform'], 'ios'); // non-secret preserved
  });

  test('no raw print/debugPrint in the notifications + push sources', () {
    final files = [
      'lib/core/services/realtime/notifications_realtime_service.dart',
      'lib/core/services/push/firebase_push_service.dart',
      'lib/core/services/push/push_registration_service.dart',
      'lib/core/data/notifications/notifications_repository_impl.dart',
    ];
    for (final path in files) {
      final src = File(path).readAsStringSync();
      expect(src.contains('print('), isFalse, reason: '$path uses print()');
      expect(
        src.contains('debugPrint('),
        isFalse,
        reason: '$path uses debugPrint()',
      );
    }
  });

  test(
    'the realtime service logs only an error string, never entry content',
    () {
      final src = File(
        'lib/core/services/realtime/notifications_realtime_service.dart',
      ).readAsStringSync();
      // The only structured log payload is the error string.
      expect(src.contains(r"data: {'e': '$e'}"), isTrue);
      expect(src.contains('entry.toJson'), isFalse);
    },
  );
}
