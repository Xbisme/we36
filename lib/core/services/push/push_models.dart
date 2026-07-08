// Plain value objects for the push seam (#013). Kept dependency-free (no
// Firebase) so the fake path + tests never touch native code.

/// The OS notification-permission verdict.
enum PushPermissionStatus { notDetermined, granted, denied }

/// A tapped push, carrying the backend's thin data payload (`{kind,
/// notificationId?}`). No get-by-id exists, so a cold tap deep-links coarsely:
/// `kind == 'message'` → Messages; any feed kind → the Activity screen.
class PushTapData {
  const PushTapData({required this.kind, this.notificationId});

  final String kind;
  final String? notificationId;

  /// DM pushes carry `kind == 'message'` (or `messageRequest`) — route to Messages.
  bool get isMessage => kind == 'message' || kind == 'messageRequest';
}

/// A foreground push to present via the local-notifications plugin (FCM does not
/// auto-display foreground messages).
class PushForegroundData {
  const PushForegroundData({
    required this.title,
    required this.body,
    this.data = const {},
  });

  final String title;
  final String body;
  final Map<String, String> data;
}

/// A registered device (response of `POST /devices`). The token is a credential
/// and is never held here — only the server-issued id + platform.
class RegisteredDevice {
  const RegisteredDevice({
    required this.id,
    required this.platform,
    required this.createdAt,
  });

  factory RegisteredDevice.fromJson(Map<String, dynamic> json) =>
      RegisteredDevice(
        id: json['id'] as String? ?? '',
        platform: json['platform'] as String? ?? '',
        createdAt:
            DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
            DateTime.utc(2026),
      );

  final String id;
  final String platform;
  final DateTime createdAt;
}
