import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart' show PostRef;
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart';
import 'package:we36/features/messaging/domain/usecases/new_message_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/new_message_state.dart';

/// Drives the new-message composer (#012 US4): people search (follows/recents
/// suggested when empty) + open-or-start a conversation on select. When opened
/// with a pending shared post (share-to-DM, US3/T041), it files the share into
/// the opened conversation.
@injectable
class NewMessageCubit extends Cubit<NewMessageState> {
  NewMessageCubit(this._search, this._openOrStart, this._sendSharedPost)
    : super(const NewMessageState.initial());

  final SearchPeople _search;
  final OpenOrStartConversation _openOrStart;
  final SendSharedPost _sendSharedPost;

  Future<void> load() => search('');

  Future<void> search(String query) async {
    emit(const NewMessageState.loading());
    final res = await _search(query);
    res.fold(
      (page) => emit(
        NewMessageState.loaded(people: page.items, query: query),
      ),
      (f) => emit(NewMessageState.error(f)),
    );
  }

  /// Open (or start) the conversation with [userId]; returns it for navigation.
  /// If [pendingShare] is set, the shared post is filed into the conversation
  /// (share-to-DM).
  Future<Result<Conversation>> openConversation(
    String userId, {
    PostRef? pendingShare,
  }) async {
    final res = await _openOrStart(userId);
    final convo = res.valueOrNull;
    if (convo != null && pendingShare != null) {
      await _sendSharedPost(convo.id, pendingShare);
    }
    return res;
  }
}
