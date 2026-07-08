import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/domain/app_failure.dart';

part 'new_message_state.freezed.dart';

/// The new-message composer people search (#012 US4; Constitution III 4-state).
@freezed
sealed class NewMessageState with _$NewMessageState {
  const factory NewMessageState.initial() = NewMessageInitial;

  const factory NewMessageState.loading() = NewMessageLoading;

  const factory NewMessageState.loaded({
    required List<UserSummary> people,
    @Default('') String query,
  }) = NewMessageLoaded;

  const factory NewMessageState.error(AppFailure failure) = NewMessageError;
}
