// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExploreItem _$ExploreItemFromJson(Map<String, dynamic> json) => _ExploreItem(
  kind: $enumDecode(_$ExploreItemKindEnumMap, json['kind']),
  post: json['post'] == null
      ? null
      : Post.fromJson(json['post'] as Map<String, dynamic>),
  reel: json['reel'] == null
      ? null
      : Reel.fromJson(json['reel'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExploreItemToJson(_ExploreItem instance) =>
    <String, dynamic>{
      'kind': _$ExploreItemKindEnumMap[instance.kind]!,
      'post': instance.post?.toJson(),
      'reel': instance.reel?.toJson(),
    };

const _$ExploreItemKindEnumMap = {
  ExploreItemKind.post: 'post',
  ExploreItemKind.reel: 'reel',
};
