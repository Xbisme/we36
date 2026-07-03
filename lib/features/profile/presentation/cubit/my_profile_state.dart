import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';

part 'my_profile_state.freezed.dart';

/// The signed-in person's own profile (#010 US1; Constitution III 4-state). The
/// header identity + counts come from `view`; `website` is the editable link from
/// the current-user identity; the grid is the active tab's cursor page.
@freezed
sealed class MyProfileState with _$MyProfileState {
  const MyProfileState._();

  const factory MyProfileState.initial() = MyProfileInitial;

  const factory MyProfileState.loading() = MyProfileLoading;

  const factory MyProfileState.loaded({
    required ProfileView view,
    required ProfileTab tab,
    required List<ExploreItem> grid,
    required bool hasMore,
    String? website,
    @Default(false) bool loadingMore,
    @Default(false) bool isOffline,
  }) = MyProfileLoaded;

  const factory MyProfileState.error(AppFailure failure) = MyProfileError;
}
