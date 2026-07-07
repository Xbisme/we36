import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';

part 'account_row.freezed.dart';
part 'account_row.g.dart';

/// One entry in a followers/following list (#010, B#010 `UserListItemDto`).
/// Reuses the shipped [UserSummary] + [ViewerRelationship]; the relationship
/// drives the row's read-write Follow control (same optimistic path as the
/// profile). Blocked accounts are server-filtered and never present (FR-016).
@freezed
abstract class AccountRow with _$AccountRow {
  const factory AccountRow({
    required UserSummary user,
    required ViewerRelationship relationship,
  }) = _AccountRow;

  factory AccountRow.fromJson(Map<String, dynamic> json) =>
      _$AccountRowFromJson(json);
}
