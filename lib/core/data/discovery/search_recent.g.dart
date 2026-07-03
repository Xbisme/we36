// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchRecent _$SearchRecentFromJson(Map<String, dynamic> json) =>
    _SearchRecent(
      id: json['id'] as String,
      type: $enumDecode(_$SearchRecentTypeEnumMap, json['type']),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      term: json['term'] as String?,
      account: json['account'] == null
          ? null
          : UserSummary.fromJson(json['account'] as Map<String, dynamic>),
      hashtag: json['hashtag'] == null
          ? null
          : HashtagResult.fromJson(json['hashtag'] as Map<String, dynamic>),
      place: json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchRecentToJson(_SearchRecent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SearchRecentTypeEnumMap[instance.type]!,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'term': instance.term,
      'account': instance.account?.toJson(),
      'hashtag': instance.hashtag?.toJson(),
      'place': instance.place?.toJson(),
    };

const _$SearchRecentTypeEnumMap = {
  SearchRecentType.term: 'term',
  SearchRecentType.account: 'account',
  SearchRecentType.hashtag: 'hashtag',
  SearchRecentType.place: 'place',
};
