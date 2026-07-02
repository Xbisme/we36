// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_engagement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentEngagement _$CommentEngagementFromJson(Map<String, dynamic> json) =>
    _CommentEngagement(
      likeCount: (json['likeCount'] as num).toInt(),
      viewerHasLiked: json['viewerHasLiked'] as bool,
    );

Map<String, dynamic> _$CommentEngagementToJson(_CommentEngagement instance) =>
    <String, dynamic>{
      'likeCount': instance.likeCount,
      'viewerHasLiked': instance.viewerHasLiked,
    };
