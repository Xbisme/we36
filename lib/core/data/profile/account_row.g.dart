// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountRow _$AccountRowFromJson(Map<String, dynamic> json) => _AccountRow(
  user: UserSummary.fromJson(json['user'] as Map<String, dynamic>),
  relationship: ViewerRelationship.fromJson(
    json['relationship'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AccountRowToJson(_AccountRow instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'relationship': instance.relationship.toJson(),
    };
