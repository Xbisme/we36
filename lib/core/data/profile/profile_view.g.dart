// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileView _$ProfileViewFromJson(Map<String, dynamic> json) => _ProfileView(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  relationship: ViewerRelationship.fromJson(
    json['relationship'] as Map<String, dynamic>,
  ),
  isMe: json['isMe'] as bool? ?? false,
  gated: json['gated'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileViewToJson(_ProfileView instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'relationship': instance.relationship.toJson(),
      'isMe': instance.isMe,
      'gated': instance.gated,
    };

_FollowResult _$FollowResultFromJson(Map<String, dynamic> json) =>
    _FollowResult(
      relationship: ViewerRelationship.fromJson(
        json['relationship'] as Map<String, dynamic>,
      ),
      followersCount: (json['followersCount'] as num).toInt(),
    );

Map<String, dynamic> _$FollowResultToJson(_FollowResult instance) =>
    <String, dynamic>{
      'relationship': instance.relationship.toJson(),
      'followersCount': instance.followersCount,
    };
