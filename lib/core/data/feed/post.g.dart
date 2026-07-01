// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => _UserSummary(
  id: json['id'] as String,
  isVerified: json['isVerified'] as bool,
  username: json['username'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$UserSummaryToJson(_UserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isVerified': instance.isVerified,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
  id: json['id'] as String,
  kind: $enumDecode(_$MediaKindEnumMap, json['kind']),
  status: $enumDecode(_$MediaStatusEnumMap, json['status']),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  durationMs: (json['durationMs'] as num?)?.toInt(),
  variants: json['variants'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$MediaKindEnumMap[instance.kind]!,
  'status': _$MediaStatusEnumMap[instance.status]!,
  'width': instance.width,
  'height': instance.height,
  'durationMs': instance.durationMs,
  'variants': instance.variants,
};

const _$MediaKindEnumMap = {MediaKind.image: 'image', MediaKind.video: 'video'};

const _$MediaStatusEnumMap = {
  MediaStatus.pending: 'pending',
  MediaStatus.processing: 'processing',
  MediaStatus.ready: 'ready',
  MediaStatus.failed: 'failed',
};

_PostMedia _$PostMediaFromJson(Map<String, dynamic> json) => _PostMedia(
  position: (json['position'] as num).toInt(),
  media: Media.fromJson(json['media'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostMediaToJson(_PostMedia instance) =>
    <String, dynamic>{
      'position': instance.position,
      'media': instance.media.toJson(),
    };

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  externalId: json['externalId'] as String?,
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'externalId': instance.externalId,
};

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  author: UserSummary.fromJson(json['author'] as Map<String, dynamic>),
  media: (json['media'] as List<dynamic>)
      .map((e) => PostMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
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
  createdAt: DateTime.parse(json['createdAt'] as String),
  caption: json['caption'] as String?,
  location: json['location'] == null
      ? null
      : Place.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author.toJson(),
  'media': instance.media.map((e) => e.toJson()).toList(),
  'hashtags': instance.hashtags,
  'taggedUsers': instance.taggedUsers.map((e) => e.toJson()).toList(),
  'commentsDisabled': instance.commentsDisabled,
  'likeCount': instance.likeCount,
  'saveCount': instance.saveCount,
  'commentCount': instance.commentCount,
  'viewerHasLiked': instance.viewerHasLiked,
  'viewerHasSaved': instance.viewerHasSaved,
  'createdAt': instance.createdAt.toIso8601String(),
  'caption': instance.caption,
  'location': instance.location?.toJson(),
};

_EngagementState _$EngagementStateFromJson(Map<String, dynamic> json) =>
    _EngagementState(
      postId: json['postId'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      saveCount: (json['saveCount'] as num).toInt(),
      viewerHasLiked: json['viewerHasLiked'] as bool,
      viewerHasSaved: json['viewerHasSaved'] as bool,
    );

Map<String, dynamic> _$EngagementStateToJson(_EngagementState instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'likeCount': instance.likeCount,
      'saveCount': instance.saveCount,
      'viewerHasLiked': instance.viewerHasLiked,
      'viewerHasSaved': instance.viewerHasSaved,
    };
