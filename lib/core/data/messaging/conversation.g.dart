// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] as String,
      participant: UserSummary.fromJson(
        json['participant'] as Map<String, dynamic>,
      ),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      isTyping: json['isTyping'] as bool? ?? false,
      participantOnline: json['participantOnline'] as bool? ?? false,
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participant': instance.participant.toJson(),
      'lastActivityAt': instance.lastActivityAt.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'lastMessagePreview': instance.lastMessagePreview,
      'isTyping': instance.isTyping,
      'participantOnline': instance.participantOnline,
    };
