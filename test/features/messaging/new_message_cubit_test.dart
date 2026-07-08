import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart';
import 'package:we36/features/messaging/domain/usecases/new_message_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/new_message_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/new_message_state.dart';

/// #012 US4: the new-message composer cubit — people search + open-or-start a
/// conversation without creating a duplicate (SC-007).
void main() {
  late FakeMessagingRepository repo;
  late NewMessageCubit cubit;

  setUp(() {
    repo = FakeMessagingRepository();
    cubit = NewMessageCubit(
      SearchPeople(repo),
      OpenOrStartConversation(repo),
      SendSharedPost(repo),
    );
  });
  tearDown(() => cubit.close());

  test('load surfaces suggested people', () async {
    await cubit.load();
    expect(cubit.state, isA<NewMessageLoaded>());
    expect((cubit.state as NewMessageLoaded).people, isNotEmpty);
  });

  test('search filters people by handle', () async {
    await cubit.search('ava');
    final people = (cubit.state as NewMessageLoaded).people;
    expect(people.any((u) => u.username == 'ava'), isTrue);
    expect(people.every((u) => u.username != 'leo'), isTrue);
  });

  test(
    'opening an existing person returns the existing conversation (no dup)',
    () async {
      final before = (await repo.watchConversations().first).length;
      final res = await cubit.openConversation('u_ava');
      expect(res.valueOrNull?.id, 'c_ava');
      final after = (await repo.watchConversations().first).length;
      expect(after, before); // no duplicate created (SC-007)
    },
  );

  test('opening a new person starts one conversation', () async {
    final before = (await repo.watchConversations().first).length;
    final res = await cubit.openConversation('u_new');
    expect(res.isOk, isTrue);
    final after = (await repo.watchConversations().first).length;
    expect(after, before + 1);
  });

  test(
    'share-to-DM files the shared post into the opened conversation',
    () async {
      final res = await cubit.openConversation(
        'u_ava',
        pendingShare: const PostRef(id: 'p1', kind: PostKind.post),
      );
      final id = res.valueOrNull!.id;
      final thread = await repo.watchThread(id).first;
      expect(thread.any((m) => m.kind == MessageKind.sharedPost), isTrue);
    },
  );
}
