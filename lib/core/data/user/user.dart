import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Public profile (reference slice for #002). Minimal contract shape from
/// `GET /v1/users/{username}`; profile #010 extends it. Ids are string UUIDv7,
/// counts integer, fields camelCase (matches the backend contract).
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String displayName,
    required bool isPrivate,
    required bool isVerified,
    required int followersCount,
    required int followingCount,
    required int postsCount,
    String? avatarUrl,
    String? bio,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
