import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Maps each [AppFailure] variant to a localized, user-facing message
/// (Constitution V/XIV) — call sites never surface raw exceptions or HTTP text.
extension AppFailureMessage on AppFailure {
  String toMessage(AppLocalizations l10n) => switch (this) {
    AppFailureUnauthenticated() => l10n.errUnauthenticated,
    AppFailureSessionExpired() => l10n.errSessionExpired,
    AppFailureInvalidCredentials() => l10n.errInvalidCredentials,
    AppFailureOauthCancelled() => l10n.errOauthCancelled,
    AppFailureOauthFailed() => l10n.errOauthFailed,
    AppFailureForbidden() => l10n.errForbidden,
    AppFailureNotFound() => l10n.errNotFound,
    AppFailureAccountSuspended() => l10n.errAccountSuspended,
    AppFailureValidation() => l10n.errValidation,
    AppFailureConflict() => l10n.errConflict,
    AppFailureRateLimited() => l10n.errRateLimited,
    AppFailureUploadFailed() => l10n.errUploadFailed,
    AppFailureMediaTooLarge() => l10n.errMediaTooLarge,
    AppFailureUnsupportedMedia() => l10n.errUnsupportedMedia,
    AppFailureCameraUnavailable() => l10n.errCameraUnavailable,
    AppFailurePermissionDenied() => l10n.errPermissionDenied,
    AppFailureRealtimeDisconnected() => l10n.errRealtimeDisconnected,
    AppFailureMessageFailed() => l10n.errMessageFailed,
    AppFailureNetworkError() => l10n.errNetwork,
    AppFailureServerError() => l10n.errServer,
    AppFailureTimeout() => l10n.errTimeout,
    AppFailureOffline() => l10n.errOffline,
    AppFailureUnknown() => l10n.errUnknown,
  };
}
