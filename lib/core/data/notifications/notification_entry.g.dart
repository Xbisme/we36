// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActorCard _$ActorCardFromJson(Map<String, dynamic> json) => _ActorCard(
  id: json['id'] as String,
  username: json['username'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$ActorCardToJson(_ActorCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };

_NotificationTarget _$NotificationTargetFromJson(Map<String, dynamic> json) =>
    _NotificationTarget(
      kind: $enumDecode(
        _$TargetKindEnumMap,
        json['kind'],
        unknownValue: TargetKind.unknown,
      ),
      id: json['id'] as String,
      postId: json['postId'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$NotificationTargetToJson(_NotificationTarget instance) =>
    <String, dynamic>{
      'kind': _$TargetKindEnumMap[instance.kind]!,
      'id': instance.id,
      'postId': instance.postId,
      'thumbnailUrl': instance.thumbnailUrl,
    };

const _$TargetKindEnumMap = {
  TargetKind.post: 'post',
  TargetKind.reel: 'reel',
  TargetKind.comment: 'comment',
  TargetKind.user: 'user',
  TargetKind.unknown: 'unknown',
};

_NotificationEntry _$NotificationEntryFromJson(Map<String, dynamic> json) =>
    _NotificationEntry(
      id: json['id'] as String,
      type: $enumDecode(
        _$NotificationTypeEnumMap,
        json['type'],
        unknownValue: NotificationType.unknown,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      actors:
          (json['actors'] as List<dynamic>?)
              ?.map((e) => ActorCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActorCard>[],
      actorCount: (json['actorCount'] as num?)?.toInt() ?? 1,
      target: json['target'] == null
          ? null
          : NotificationTarget.fromJson(json['target'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationEntryToJson(_NotificationEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'actors': instance.actors.map((e) => e.toJson()).toList(),
      'actorCount': instance.actorCount,
      'target': instance.target?.toJson(),
      'isRead': instance.isRead,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.like: 'like',
  NotificationType.comment: 'comment',
  NotificationType.reply: 'reply',
  NotificationType.mention: 'mention',
  NotificationType.follow: 'follow',
  NotificationType.followRequest: 'followRequest',
  NotificationType.followAccepted: 'followAccepted',
  NotificationType.unknown: 'unknown',
};
