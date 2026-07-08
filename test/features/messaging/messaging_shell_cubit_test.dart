import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/features/messaging/presentation/cubit/messaging_shell_cubit.dart';

/// #012 US5 (T049): the tablet two-pane selection holder. Selecting a
/// conversation swaps the detail pane in place — a pure state change, never a
/// route push (SC-008). Both panes bind this shared selection.
void main() {
  Conversation convo(String id) => Conversation(
    id: id,
    participant: UserSummary(id: 'p_$id', isVerified: false, username: id),
    lastActivityAt: DateTime.utc(2026),
  );

  test('starts with no selection (empty detail pane)', () {
    final cubit = MessagingShellCubit();
    addTearDown(cubit.close);
    expect(cubit.state, isNull);
  });

  test('select swaps the detail selection in place', () {
    final cubit = MessagingShellCubit();
    addTearDown(cubit.close);

    cubit.select(convo('c_ava'));
    expect(cubit.state?.id, 'c_ava');

    // Selecting another swaps the pane (no push, just new state).
    cubit.select(convo('c_leo'));
    expect(cubit.state?.id, 'c_leo');
  });
}
