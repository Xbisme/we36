import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/domain/result.dart';

/// The account settings surface (#014). A real impl (`env:['real']`) binds to
/// `GET`/`PATCH /me/settings`; an in-memory fake (`env:['fake']`, the one that
/// runs in tests) mirrors the same behaviour.
abstract interface class SettingsRepository {
  /// Load the current settings.
  Future<Result<AccountSettings>> getSettings();

  /// Set account privacy (private/public). Going public server-side
  /// auto-accepts pending follow requests.
  Future<Result<AccountSettings>> setPrivate({required bool isPrivate});

  /// Set reciprocal activity-status visibility.
  Future<Result<AccountSettings>> setActivityStatus({required bool visible});
}
