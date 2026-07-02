// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentAuthor _$CommentAuthorFromJson(Map<String, dynamic> json) =>
    _CommentAuthor(
      id: json['id'] as String,
      isVerified: json['isVerified'] as bool,
      username: json['username'] as String?,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$CommentAuthorToJson(_CommentAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isVerified': instance.isVerified,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  postId: json['postId'] as String,
  author: CommentAuthor.fromJson(json['author'] as Map<String, dynamic>),
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  likeCount: (json['likeCount'] as num).toInt(),
  viewerHasLiked: json['viewerHasLiked'] as bool,
  isOwn: json['isOwn'] as bool,
  replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
  parentId: json['parentId'] as String?,
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'author': instance.author.toJson(),
  'text': instance.text,
  'createdAt': instance.createdAt.toIso8601String(),
  'likeCount': instance.likeCount,
  'viewerHasLiked': instance.viewerHasLiked,
  'isOwn': instance.isOwn,
  'replyCount': instance.replyCount,
  'parentId': instance.parentId,
};
