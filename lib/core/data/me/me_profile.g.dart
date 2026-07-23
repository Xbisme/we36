// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeProfile _$MeProfileFromJson(Map<String, dynamic> json) => _MeProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  isPrivate: json['isPrivate'] as bool,
  isVerified: json['isVerified'] as bool,
  profileCompleted: json['profileCompleted'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  username: json['username'] as String?,
  displayName: json['displayName'] as String?,
  avatarMediaId: json['avatarMediaId'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
  website: json['website'] as String?,
  pronouns: json['pronouns'] as String?,
);

Map<String, dynamic> _$MeProfileToJson(_MeProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isPrivate': instance.isPrivate,
      'isVerified': instance.isVerified,
      'profileCompleted': instance.profileCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarMediaId': instance.avatarMediaId,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'website': instance.website,
      'pronouns': instance.pronouns,
    };
