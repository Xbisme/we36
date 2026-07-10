import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for the account settings surface (#014, B#014) via the shared
/// [ApiClient]. Decodes the backend `SettingsView`; `PATCH` is naturally
/// idempotent (last-write-wins on the sent fields).
@lazySingleton
class SettingsRemoteDataSource {
  const SettingsRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<AccountSettings>> getSettings() => _api.get<AccountSettings>(
    ApiEndpoints.meSettings,
    decode: (data) => _decode((data as Map).cast<String, dynamic>()),
  );

  Future<Result<AccountSettings>> patch(Map<String, dynamic> body) =>
      _api.patch<AccountSettings>(
        ApiEndpoints.meSettings,
        body: body,
        decode: (data) => _decode((data as Map).cast<String, dynamic>()),
      );

  static AccountSettings _decode(Map<String, dynamic> json) {
    final n = (json['notifications'] as Map?)?.cast<String, dynamic>() ?? {};
    return AccountSettings(
      isPrivate: json['isPrivate'] as bool? ?? false,
      activityStatusVisible: json['activityStatusVisible'] as bool? ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      closeFriendsCount: (json['closeFriendsCount'] as num?)?.toInt() ?? 0,
      notifications: NotificationPrefs(
        likes: n['likes'] as bool? ?? true,
        comments: n['comments'] as bool? ?? true,
        mentions: n['mentions'] as bool? ?? true,
        follows: n['follows'] as bool? ?? true,
        followRequests: n['followRequests'] as bool? ?? true,
        directMessages: n['directMessages'] as bool? ?? true,
        globalMute: n['globalMute'] as bool? ?? false,
      ),
    );
  }
}
