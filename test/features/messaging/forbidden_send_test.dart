import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/domain/app_failure.dart';

/// #012 FR-027 (T038a): the client reflects the backend's block verdict — a
/// forbidden send surfaces an `AppFailure.forbidden` and the optimistic row is
/// marked `failed`; the client invents no visibility rule of its own.
void main() {
  test(
    'a forbidden send surfaces failure + marks the message failed',
    () async {
      final repo = FakeMessagingRepository()
        // The backend rejects the send (a blocked peer).
        ..nextSendFailure = const AppFailure.forbidden();

      final res = await repo.sendText('c_mia', 'hi');

      expect(res.isErr, isTrue);
      expect(res.failureOrNull, isA<AppFailureForbidden>());

      final thread = await repo.watchThread('c_mia').first;
      expect(thread.single.deliveryState, DeliveryState.failed);
    },
  );
}
