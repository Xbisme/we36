import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';

part 'profile_state.freezed.dart';

/// Another person's profile (#010 US2/US4; Constitution III 4-state). Carries the
/// `ProfileView` (identity + counts + relationship + gating), the active grid
/// tab, and a transient `followBusy` flag while a follow mutation is in flight.
@freezed
sealed class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.initial() = ProfileInitial;

  const factory ProfileState.loading() = ProfileLoading;

  const factory ProfileState.loaded({
    required ProfileView view,
    required ProfileTab tab,
    required List<ExploreItem> grid,
    required bool hasMore,
    @Default(false) bool loadingMore,
    @Default(false) bool followBusy,
  }) = ProfileLoaded;

  const factory ProfileState.error(AppFailure failure) = ProfileError;
}
