import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/notifications/fake_notifications_repository.dart';
import 'package:we36/core/services/push/fake_push_service.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/services/push/push_registration_service.dart';
import 'package:we36/features/notifications/domain/usecases/push_usecases.dart';
import 'package:we36/features/notifications/presentation/cubit/push_permission_cubit.dart';

void main() {
  group('PushPermissionCubit (US2 gate)', () {
    test(
      'ensure reflects the current status; affordance hidden when granted',
      () async {
        final push = FakePushService()
          ..scriptedStatus = PushPermissionStatus.granted;
        final cubit = PushPermissionCubit(push);
        await cubit.ensure();
        expect(cubit.state, PushPermissionStatus.granted);
        expect(cubit.showAffordance, isFalse);
        await cubit.close();
      },
    );

    test('request prompts once and reflects grant', () async {
      final push = FakePushService()
        ..scriptedStatus = PushPermissionStatus.granted;
      final cubit = PushPermissionCubit(push);
      await cubit.request();
      expect(push.requestCount, 1);
      expect(cubit.state, PushPermissionStatus.granted);
      await cubit.close();
    });

    test('denied keeps the affordance visible (no auto-renag)', () async {
      final push = FakePushService()
        ..scriptedStatus = PushPermissionStatus.denied;
      final cubit = PushPermissionCubit(push);
      await cubit.ensure();
      expect(cubit.showAffordance, isTrue);
      await cubit.close();
    });
  });

  group('PushRegistrationService (US2 lifecycle)', () {
    test('registers each token; unregisters on logout (idempotent)', () async {
      final push = FakePushService();
      final repo = FakeNotificationsRepository();
      final service = PushRegistrationService(push, repo);
      addTearDown(service.dispose);

      push.emitToken('tok-1');
      await Future<void>.delayed(Duration.zero);
      expect(repo.registeredTokens, contains('tok-1'));

      await service.unregister();
      expect(repo.unregisteredTokens, contains('tok-1'));

      // Idempotent — a second unregister is a no-op.
      await service.unregister();
      expect(repo.unregisteredTokens, hasLength(1));
    });
  });

  group('pushTapRoute (US5 coarse deep-link)', () {
    test('a DM push routes to Messages', () {
      expect(
        pushTapRoute(const PushTapData(kind: 'message')),
        AppRoutes.messages,
      );
    });

    test('a feed-activity push routes to Activity', () {
      expect(
        pushTapRoute(const PushTapData(kind: 'like', notificationId: 'n1')),
        AppRoutes.notifications,
      );
    });
  });
}
