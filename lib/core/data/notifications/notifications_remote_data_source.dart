import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/data/notifications/notifications_dto.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/push/push_models.dart';

/// Remote source for Notifications & Push (#013) via the shared [ApiClient] —
/// SOURCE-VERIFIED B#013 shapes (`contracts/notifications-api.md`). The feed is a
/// cursor page of grouped entries; mark-all-read + device register/unregister are
/// simple mutations. Push tokens are credentials — passed through, never logged.
@lazySingleton
class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._api);

  final ApiClient _api;

  /// The grouped Activity feed (`GET /notifications`, cursor, newest first).
  Future<Result<CursorPage<NotificationEntry>>> list({String? cursor}) =>
      _api.get<CursorPage<NotificationEntry>>(
        ApiEndpoints.notifications,
        query: cursor == null ? null : {'cursor': cursor},
        decode: (data) => CursorPage<NotificationEntry>.fromJson(
          (data as Map).cast<String, dynamic>(),
          notificationEntryFromDto,
        ),
      );

  /// The caller's unread count (`GET /notifications/unread-count` → `{count}`).
  Future<Result<int>> unreadCount() => _api.get<int>(
    ApiEndpoints.notificationsUnreadCount,
    decode: (data) => ((data as Map)['count'] as num?)?.toInt() ?? 0,
  );

  /// Mark all read (`POST /notifications/read` → 204).
  Future<Result<void>> markAllRead() => _api.post<void>(
    ApiEndpoints.notificationsRead,
    decode: (_) {},
  );

  /// Register/refresh this device's push token (`POST /devices`).
  Future<Result<RegisteredDevice>> registerDevice(
    String platform,
    String token,
  ) => _api.post<RegisteredDevice>(
    ApiEndpoints.devices,
    body: registerDeviceBody(platform, token),
    decode: (data) =>
        RegisteredDevice.fromJson((data as Map).cast<String, dynamic>()),
  );

  /// Unregister a device token (`DELETE /devices/:token` → 204, idempotent).
  Future<Result<void>> unregisterDevice(String token) => _api.delete<void>(
    ApiEndpoints.device(token),
    decode: (_) {},
  );

  /// The current platform string for [registerDevice] (`ios` | `android`).
  static String get platformName => Platform.isIOS ? 'ios' : 'android';
}
