// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reel _$ReelFromJson(Map<String, dynamic> json) => _Reel(
  id: json['id'] as String,
  author: UserSummary.fromJson(json['author'] as Map<String, dynamic>),
  video: Media.fromJson(json['video'] as Map<String, dynamic>),
  hashtags: (json['hashtags'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  taggedUsers: (json['taggedUsers'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  commentsDisabled: json['commentsDisabled'] as bool,
  likeCount: (json['likeCount'] as num).toInt(),
  saveCount: (json['saveCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  viewerHasLiked: json['viewerHasLiked'] as bool,
  viewerHasSaved: json['viewerHasSaved'] as bool,
  isVideoReady: json['isVideoReady'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  caption: json['caption'] as String?,
  location: json['location'] == null
      ? null
      : Place.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReelToJson(_Reel instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author.toJson(),
  'video': instance.video.toJson(),
  'hashtags': instance.hashtags,
  'taggedUsers': instance.taggedUsers.map((e) => e.toJson()).toList(),
  'commentsDisabled': instance.commentsDisabled,
  'likeCount': instance.likeCount,
  'saveCount': instance.saveCount,
  'commentCount': instance.commentCount,
  'viewerHasLiked': instance.viewerHasLiked,
  'viewerHasSaved': instance.viewerHasSaved,
  'isVideoReady': instance.isVideoReady,
  'createdAt': instance.createdAt.toIso8601String(),
  'caption': instance.caption,
  'location': instance.location?.toJson(),
};
