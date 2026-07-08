import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/conversation.dart';

/// Holds the selected conversation for the tablet two-pane (#012 US5) — selecting
/// a row swaps the detail pane in place (no route push). Phone layouts ignore it
/// (they push the chat route). A pure UI-selection holder, not a data cubit.
@injectable
class MessagingShellCubit extends Cubit<Conversation?> {
  MessagingShellCubit() : super(null);

  void select(Conversation conversation) => emit(conversation);
}
