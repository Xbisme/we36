import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_profile.freezed.dart';
part 'me_profile.g.dart';

/// The authenticated current user (#003). Mirrors the backend `MeProfile`
/// (`GET /v1/me`, `POST /v1/me/setup`, `PATCH /v1/me`). Distinct from the public
/// `User` slice: it carries auth-sensitive fields (email) and the
/// [profileCompleted] flag that drives post-auth routing. Fields are camelCase;
/// `username`/`displayName` are null until profile setup completes.
@freezed
abstract class MeProfile with _$MeProfile {
  const factory MeProfile({
    required String id,
    required String email,
    required bool isPrivate,
    required bool isVerified,
    required bool profileCompleted,
    required DateTime createdAt,
    String? username,
    String? displayName,
    String? avatarMediaId,
    String? avatarUrl,
    String? bio,
    String? website,
    String? pronouns,
  }) = _MeProfile;

  factory MeProfile.fromJson(Map<String, dynamic> json) =>
      _$MeProfileFromJson(json);
}
