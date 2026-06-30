import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// The shared, typed failure vocabulary every repository and Cubit returns
/// (Constitution V). #001 only exercises a few variants (e.g. `unknown`,
/// `offline`); the full set is declared now so #002+ never re-edit it.
@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.unauthenticated() = AppFailureUnauthenticated;
  const factory AppFailure.sessionExpired() = AppFailureSessionExpired;
  const factory AppFailure.invalidCredentials() = AppFailureInvalidCredentials;
  const factory AppFailure.oauthCancelled() = AppFailureOauthCancelled;
  const factory AppFailure.oauthFailed() = AppFailureOauthFailed;

  const factory AppFailure.forbidden() = AppFailureForbidden;
  const factory AppFailure.notFound() = AppFailureNotFound;
  const factory AppFailure.accountSuspended() = AppFailureAccountSuspended;

  const factory AppFailure.validation({
    required Map<String, String> fields,
  }) = AppFailureValidation;
  const factory AppFailure.conflict() = AppFailureConflict;
  const factory AppFailure.rateLimited() = AppFailureRateLimited;

  const factory AppFailure.uploadFailed() = AppFailureUploadFailed;
  const factory AppFailure.mediaTooLarge() = AppFailureMediaTooLarge;
  const factory AppFailure.unsupportedMedia() = AppFailureUnsupportedMedia;
  const factory AppFailure.cameraUnavailable() = AppFailureCameraUnavailable;
  const factory AppFailure.permissionDenied() = AppFailurePermissionDenied;

  const factory AppFailure.realtimeDisconnected() =
      AppFailureRealtimeDisconnected;
  const factory AppFailure.messageFailed() = AppFailureMessageFailed;

  const factory AppFailure.networkError() = AppFailureNetworkError;
  const factory AppFailure.serverError() = AppFailureServerError;
  const factory AppFailure.timeout() = AppFailureTimeout;
  const factory AppFailure.offline() = AppFailureOffline;

  const factory AppFailure.unknown({String? message, Object? error}) =
      AppFailureUnknown;
}
