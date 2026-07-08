import 'package:we36/core/services/push/push_models.dart';

/// The push transport seam (#013, Constitution VIII spirit). A real
/// `firebase_messaging` binding (`env:['real']`) and an in-memory fake
/// (`env:['fake']`, the one that runs) exist so the whole surface is testable
/// with zero network and no Firebase. Cubits/widgets never touch Firebase — they
/// go through use cases over this seam. Device register/unregister is REST (the
/// repository), driven by [tokenStream] + logout — not this service.
abstract interface class PushService {
  /// Request OS notification permission (contextual — first Activity open).
  Future<PushPermissionStatus> requestPermission();

  /// The current permission status without prompting.
  Future<PushPermissionStatus> currentStatus();

  /// The FCM/APNs token + rotations (each feeds `RegisterDevice`). Emits the
  /// current token on listen when available.
  Stream<String> get tokenStream;

  /// A tapped notification (`{kind, notificationId?}`) → coarse deep-link.
  Stream<PushTapData> get onNotificationTap;

  /// A foreground message to present locally (FCM won't auto-display these).
  Stream<PushForegroundData> get onForegroundMessage;

  /// The tap that cold-started the app, if any (drives initial deep-link).
  Future<PushTapData?> initialTap();
}
