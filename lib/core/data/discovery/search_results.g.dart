// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ViewerRelationship _$ViewerRelationshipFromJson(Map<String, dynamic> json) =>
    _ViewerRelationship(
      following: json['following'] as bool,
      requested: json['requested'] as bool,
      followsYou: json['followsYou'] as bool,
      blocking: json['blocking'] as bool,
    );

Map<String, dynamic> _$ViewerRelationshipToJson(_ViewerRelationship instance) =>
    <String, dynamic>{
      'following': instance.following,
      'requested': instance.requested,
      'followsYou': instance.followsYou,
      'blocking': instance.blocking,
    };

_AccountResult _$AccountResultFromJson(Map<String, dynamic> json) =>
    _AccountResult(
      user: UserSummary.fromJson(json['user'] as Map<String, dynamic>),
      relationship: ViewerRelationship.fromJson(
        json['relationship'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AccountResultToJson(_AccountResult instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'relationship': instance.relationship.toJson(),
    };

_HashtagResult _$HashtagResultFromJson(Map<String, dynamic> json) =>
    _HashtagResult(
      tag: json['tag'] as String,
      postCount: (json['postCount'] as num).toInt(),
    );

Map<String, dynamic> _$HashtagResultToJson(_HashtagResult instance) =>
    <String, dynamic>{'tag': instance.tag, 'postCount': instance.postCount};

_PlaceResult _$PlaceResultFromJson(Map<String, dynamic> json) => _PlaceResult(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PlaceResultToJson(_PlaceResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_SearchTop _$SearchTopFromJson(Map<String, dynamic> json) => _SearchTop(
  accounts: (json['accounts'] as List<dynamic>)
      .map((e) => AccountResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  hashtags: (json['hashtags'] as List<dynamic>)
      .map((e) => HashtagResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  places: (json['places'] as List<dynamic>)
      .map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchTopToJson(_SearchTop instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'hashtags': instance.hashtags.map((e) => e.toJson()).toList(),
      'places': instance.places.map((e) => e.toJson()).toList(),
    };
