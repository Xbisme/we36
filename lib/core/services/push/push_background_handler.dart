import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// FCM background/killed-state handler (#013). Runs in a **separate isolate** with
/// no app state, so it must init Firebase itself and stay minimal. For We36's
/// coarse push the OS auto-displays the `notification` payload; the deep-link is
/// resolved on tap in the foreground isolate (`onNotificationTap`). Top-level +
/// `@pragma('vm:entry-point')` are required for release/AOT builds.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
