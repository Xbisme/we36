// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_collections_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionPickerRow _$CollectionPickerRowFromJson(Map<String, dynamic> json) =>
    _CollectionPickerRow(
      collection: SavedCollection.fromJson(
        json['collection'] as Map<String, dynamic>,
      ),
      contains: json['contains'] as bool,
    );

Map<String, dynamic> _$CollectionPickerRowToJson(
  _CollectionPickerRow instance,
) => <String, dynamic>{
  'collection': instance.collection.toJson(),
  'contains': instance.contains,
};

_PostCollectionsMembership _$PostCollectionsMembershipFromJson(
  Map<String, dynamic> json,
) => _PostCollectionsMembership(
  postId: json['postId'] as String,
  isSaved: json['isSaved'] as bool,
  collections:
      (json['collections'] as List<dynamic>?)
          ?.map((e) => CollectionPickerRow.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CollectionPickerRow>[],
);

Map<String, dynamic> _$PostCollectionsMembershipToJson(
  _PostCollectionsMembership instance,
) => <String, dynamic>{
  'postId': instance.postId,
  'isSaved': instance.isSaved,
  'collections': instance.collections.map((e) => e.toJson()).toList(),
};
