// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostRef _$PostRefFromJson(Map<String, dynamic> json) => _PostRef(
  id: json['id'] as String,
  kind: $enumDecode(_$PostKindEnumMap, json['kind']),
  thumbUrl: json['thumbUrl'] as String?,
  authorName: json['authorName'] as String?,
  unavailable: json['unavailable'] as bool? ?? false,
);

Map<String, dynamic> _$PostRefToJson(_PostRef instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$PostKindEnumMap[instance.kind]!,
  'thumbUrl': instance.thumbUrl,
  'authorName': instance.authorName,
  'unavailable': instance.unavailable,
};

const _$PostKindEnumMap = {PostKind.post: 'post', PostKind.reel: 'reel'};

TextContent _$TextContentFromJson(Map<String, dynamic> json) => TextContent(
  body: json['body'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$TextContentToJson(TextContent instance) =>
    <String, dynamic>{'body': instance.body, 'runtimeType': instance.$type};

PhotoContent _$PhotoContentFromJson(Map<String, dynamic> json) => PhotoContent(
  mediaId: json['mediaId'] as String?,
  localPath: json['localPath'] as String?,
  url: json['url'] as String?,
  uploadProgress: (json['uploadProgress'] as num?)?.toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PhotoContentToJson(PhotoContent instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'localPath': instance.localPath,
      'url': instance.url,
      'uploadProgress': instance.uploadProgress,
      'runtimeType': instance.$type,
    };

SharedPostContent _$SharedPostContentFromJson(Map<String, dynamic> json) =>
    SharedPostContent(
      ref: PostRef.fromJson(json['ref'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SharedPostContentToJson(SharedPostContent instance) =>
    <String, dynamic>{
      'ref': instance.ref.toJson(),
      'runtimeType': instance.$type,
    };

StickerContent _$StickerContentFromJson(Map<String, dynamic> json) =>
    StickerContent(
      glyphId: json['glyphId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StickerContentToJson(StickerContent instance) =>
    <String, dynamic>{
      'glyphId': instance.glyphId,
      'runtimeType': instance.$type,
    };

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  clientKey: json['clientKey'] as String,
  conversationId: json['conversationId'] as String,
  authorId: json['authorId'] as String,
  isMine: json['isMine'] as bool,
  kind: $enumDecode(_$MessageKindEnumMap, json['kind']),
  content: MessageContent.fromJson(json['content'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  deliveryState: $enumDecode(_$DeliveryStateEnumMap, json['deliveryState']),
  serverId: json['serverId'] as String?,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'clientKey': instance.clientKey,
  'conversationId': instance.conversationId,
  'authorId': instance.authorId,
  'isMine': instance.isMine,
  'kind': _$MessageKindEnumMap[instance.kind]!,
  'content': instance.content.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'deliveryState': _$DeliveryStateEnumMap[instance.deliveryState]!,
  'serverId': instance.serverId,
};

const _$MessageKindEnumMap = {
  MessageKind.text: 'text',
  MessageKind.photo: 'photo',
  MessageKind.sharedPost: 'sharedPost',
  MessageKind.sticker: 'sticker',
};

const _$DeliveryStateEnumMap = {
  DeliveryState.sending: 'sending',
  DeliveryState.sent: 'sent',
  DeliveryState.delivered: 'delivered',
  DeliveryState.read: 'read',
  DeliveryState.failed: 'failed',
};
