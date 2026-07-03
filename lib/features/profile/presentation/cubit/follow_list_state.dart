import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';

part 'follow_list_state.freezed.dart';

/// The followers/following list (#010 US3; Constitution III 4-state). Holds the
/// active `tab`, the current search `query`, and the paginated rows.
@freezed
sealed class FollowListState with _$FollowListState {
  const FollowListState._();

  const factory FollowListState.initial() = FollowListInitial;

  const factory FollowListState.loading() = FollowListLoading;

  const factory FollowListState.loaded({
    required FollowConnTab tab,
    required List<AccountRow> rows,
    required bool hasMore,
    @Default('') String query,
    @Default(false) bool loadingMore,
  }) = FollowListLoaded;

  const factory FollowListState.error(AppFailure failure) = FollowListError;
}
