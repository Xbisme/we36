// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedCollection _$SavedCollectionFromJson(Map<String, dynamic> json) =>
    _SavedCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      itemCount: (json['itemCount'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coverRefs:
          (json['coverRefs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$SavedCollectionToJson(_SavedCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'itemCount': instance.itemCount,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'coverRefs': instance.coverRefs,
      'isDefault': instance.isDefault,
    };
