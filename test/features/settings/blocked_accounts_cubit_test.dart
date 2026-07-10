import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/moderation/block_actions.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/moderation/fake_block_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/features/settings/presentation/cubit/blocked_accounts_cubit.dart';

BlockedAccountsCubit _cubit(
  FakeBlockRepository repo,
  BlockedUsersStore blocked,
) {
  final actions = BlockActions(repo, RelationshipStore(), blocked);
  return BlockedAccountsCubit(repo, actions, blocked);
}

void main() {
  group('BlockedAccountsCubit (#014 US3)', () {
    test('load emits the blocked list and seeds the store', () async {
      final blocked = BlockedUsersStore();
      final cubit = _cubit(FakeBlockRepository(), blocked);
      await cubit.load();
      expect(cubit.state.dataOrNull, isNotEmpty);
      expect(blocked.current, isNotEmpty);
      await cubit.close();
    });

    test('unblock optimistically removes the row', () async {
      final blocked = BlockedUsersStore();
      final repo = FakeBlockRepository();
      final cubit = _cubit(repo, blocked);
      await cubit.load();
      final target = cubit.state.dataOrNull!.first;

      await cubit.unblock(target);

      expect(
        cubit.state.dataOrNull!.any((u) => u.id == target.id),
        isFalse,
      );
      expect(blocked.isBlocked(target.id), isFalse);
      await cubit.close();
    });
  });
}
