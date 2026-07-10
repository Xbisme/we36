import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/preferences/presence_visibility.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/utils/app_logger.dart';

/// #014 US6 (FR-028): when activity status is off, the messaging service
/// reciprocally hides others' presence + typing.
void main() {
  test('presence/typing are hidden when activity status is off', () async {
    final client = FakeRealtimeClient();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final visibility = PresenceVisibility();
    final service = MessagingRealtimeService(
      client,
      db,
      const AppLogger(),
      visibility,
    );
    addTearDown(service.dispose);

    client.emitInbound(const PresenceUpdate(userId: 'u1', online: true));
    await Future<void>.delayed(Duration.zero);
    expect(service.isOnline('u1'), isTrue);

    // Turn activity status off → reciprocal hide.
    visibility.visible = false;
    expect(service.isOnline('u1'), isFalse);

    // Back on → visible again.
    visibility.visible = true;
    expect(service.isOnline('u1'), isTrue);
  });
}
