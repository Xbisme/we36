import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'chat_state.freezed.dart';

/// One conversation's chat surface (#012 US2; Constitution III 4-state). The
/// loaded state carries the thread (oldest→newest) plus the peer's live typing +
/// presence (decorated from the realtime streams — transient).
@freezed
sealed class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState.initial() = ChatInitial;

  const factory ChatState.loading() = ChatLoading;

  const factory ChatState.loaded({
    required List<Message> messages,
    @Default(false) bool peerTyping,
    @Default(false) bool peerOnline,
  }) = ChatLoaded;

  const factory ChatState.error(AppFailure failure) = ChatError;
}
