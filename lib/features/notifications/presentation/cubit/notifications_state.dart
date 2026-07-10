import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/notifications/domain/usecases/notifications_usecases.dart';

part 'notifications_state.freezed.dart';

/// The Activity feed state (#013 US1; Constitution III 4-state). The loaded state
/// carries the time-sectioned groups (New / This week / Earlier), the pagination
/// flags, and an offline hint when a background reconcile failed but the cache
/// rendered.
@freezed
sealed class NotificationsState with _$NotificationsState {
  const NotificationsState._();

  const factory NotificationsState.initial() = NotificationsInitial;

  const factory NotificationsState.loading() = NotificationsLoading;

  const factory NotificationsState.loaded({
    required List<NotificationSectionGroup> sections,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    @Default(false) bool isOffline,
  }) = NotificationsLoaded;

  const factory NotificationsState.error(AppFailure failure) =
      NotificationsError;

  /// Whether the loaded feed has zero entries (empty-state gate).
  bool get isEmpty => switch (this) {
    NotificationsLoaded(:final sections) => sections.isEmpty,
    _ => false,
  };
}
