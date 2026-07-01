// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaceRef _$PlaceRefFromJson(Map<String, dynamic> json) =>
    _PlaceRef(label: json['label'] as String, id: json['id'] as String?);

Map<String, dynamic> _$PlaceRefToJson(_PlaceRef instance) => <String, dynamic>{
  'label': instance.label,
  'id': instance.id,
};

_PostMetadata _$PostMetadataFromJson(Map<String, dynamic> json) =>
    _PostMetadata(
      taggedUserIds:
          (json['taggedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      location: json['location'] == null
          ? null
          : PlaceRef.fromJson(json['location'] as Map<String, dynamic>),
      commentsDisabled: json['commentsDisabled'] as bool? ?? false,
    );

Map<String, dynamic> _$PostMetadataToJson(_PostMetadata instance) =>
    <String, dynamic>{
      'taggedUserIds': instance.taggedUserIds,
      'location': instance.location?.toJson(),
      'commentsDisabled': instance.commentsDisabled,
    };
