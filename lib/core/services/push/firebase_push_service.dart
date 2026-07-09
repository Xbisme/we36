import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/push/push_background_handler.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/services/push/push_service.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Real [PushService] over `firebase_messaging` + `flutter_local_notifications`
/// (#013). Registered only in `env:['real']` — the app runs the fake, so this
/// (and Firebase) never load in tests / fake mode. `Firebase.initializeApp()` is
/// **guarded on config presence**: without a platform options file (deferred to
/// cutover/#015) it degrades to unavailable rather than throwing at launch. Push
/// tokens are credentials — never logged.
@LazySingleton(as: PushService, env: ['real'])
class FirebasePushService implements PushService {
  FirebasePushService(this._logger);

  final AppLogger _logger;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final StreamController<String> _tokens = StreamController<String>.broadcast();
  final StreamController<PushTapData> _taps =
      StreamController<PushTapData>.broadcast();
  final StreamController<PushForegroundData> _fg =
      StreamController<PushForegroundData>.broadcast();

  FirebaseMessaging? _fm;
  bool _initFailed = false;
  bool _wired = false;

  @override
  Future<void> initialize() async {
    // Eagerly bring Firebase up + register the background handler at startup so a
    // killed/backgrounded app receives pushes. Guarded — a no-op when unconfigured.
    final fm = await _messaging();
    if (fm == null) return;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Lazily bring Firebase up (guarded). Returns null when unconfigured.
  Future<FirebaseMessaging?> _messaging() async {
    if (_fm != null) return _fm;
    if (_initFailed) return null;
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      _fm = FirebaseMessaging.instance;
      await _wire();
      return _fm;
    } on Object catch (e) {
      _initFailed = true; // no platform config yet (deferred to cutover/#015)
      _logger.warn(
        'Push unavailable (Firebase not configured)',
        data: {'e': '$e'},
      );
      return null;
    }
  }

  Future<void> _wire() async {
    if (_wired) return;
    _wired = true;
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _local.initialize(settings: init);
    _fm!.onTokenRefresh.listen(_tokens.add);
    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _taps.add(_toTap(m)),
    );
  }

  void _onForeground(RemoteMessage m) {
    _fg.add(_toForeground(m));
    // Present locally — FCM does not auto-display a foreground message.
    final n = m.notification;
    if (n != null) {
      unawaited(
        _local.show(
          id: m.hashCode,
          title: n.title,
          body: n.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'we36_activity',
              'Activity',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        ),
      );
    }
  }

  @override
  Future<PushPermissionStatus> requestPermission() async {
    final fm = await _messaging();
    if (fm == null) return PushPermissionStatus.denied;
    final settings = await fm.requestPermission();
    final status = _mapAuth(settings.authorizationStatus);
    if (status == PushPermissionStatus.granted) {
      final token = await fm.getToken();
      if (token != null) _tokens.add(token);
    }
    return status;
  }

  @override
  Future<PushPermissionStatus> currentStatus() async {
    final fm = await _messaging();
    if (fm == null) return PushPermissionStatus.denied;
    final settings = await fm.getNotificationSettings();
    return _mapAuth(settings.authorizationStatus);
  }

  @override
  Stream<String> get tokenStream => _tokens.stream;

  @override
  Stream<PushTapData> get onNotificationTap => _taps.stream;

  @override
  Stream<PushForegroundData> get onForegroundMessage => _fg.stream;

  @override
  Future<PushTapData?> initialTap() async {
    final fm = await _messaging();
    if (fm == null) return null;
    final m = await fm.getInitialMessage();
    return m == null ? null : _toTap(m);
  }

  PushPermissionStatus _mapAuth(AuthorizationStatus s) => switch (s) {
    AuthorizationStatus.authorized ||
    AuthorizationStatus.provisional => PushPermissionStatus.granted,
    AuthorizationStatus.denied => PushPermissionStatus.denied,
    _ => PushPermissionStatus.notDetermined,
  };

  PushTapData _toTap(RemoteMessage m) => PushTapData(
    kind: m.data['kind'] as String? ?? '',
    notificationId: m.data['notificationId'] as String?,
  );

  PushForegroundData _toForeground(RemoteMessage m) => PushForegroundData(
    title: m.notification?.title ?? '',
    body: m.notification?.body ?? '',
    data: m.data.map((k, v) => MapEntry(k, '$v')),
  );
}
