import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_username.freezed.dart';
part 'check_username.g.dart';

/// Why a candidate username is unavailable (backend `reason`); null on the wire
/// when [UsernameAvailability.available] is true.
enum UsernameReason { taken, invalid }

/// Result of `POST /v1/auth/check-username` (case-insensitive availability +
/// format validation).
@freezed
abstract class UsernameAvailability with _$UsernameAvailability {
  const factory UsernameAvailability({
    required bool available,
    UsernameReason? reason,
  }) = _UsernameAvailability;

  factory UsernameAvailability.fromJson(Map<String, dynamic> json) =>
      _$UsernameAvailabilityFromJson(json);
}
