import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_state.dart';

/// #010 T038: followers/following list — load, search, tab switch, row toggle
/// (canonical store), block exclusion.
void main() {
  late RelationshipStore store;
  late FakeProfileRepository repo;

  FollowListCubit build() =>
      FollowListCubit(LoadConnections(repo), FollowAction(repo, store), store);

  setUp(() {
    store = RelationshipStore();
    repo = FakeProfileRepository(store);
  });

  test('init loads the followers list and excludes blocked', () async {
    final cubit = build();
    await cubit.init('u_alice_travel', FollowConnTab.followers);
    final loaded = cubit.state as FollowListLoaded;
    expect(loaded.rows, isNotEmpty);
    expect(
      loaded.rows.every((r) => r.user.username != 'blocked_user'),
      isTrue,
    );
    await cubit.close();
  });

  test('search narrows the rows', () async {
    final cubit = build();
    await cubit.init('u_alice_travel', FollowConnTab.followers);
    await cubit.search('grace');
    final loaded = cubit.state as FollowListLoaded;
    expect(loaded.rows, isNotEmpty);
    expect(
      loaded.rows.every((r) => (r.user.username ?? '').contains('grace')),
      isTrue,
    );
    await cubit.close();
  });

  test('switchTab reloads the following list', () async {
    final cubit = build();
    await cubit.init('u_alice_travel', FollowConnTab.followers);
    await cubit.switchTab(FollowConnTab.following);
    expect((cubit.state as FollowListLoaded).tab, FollowConnTab.following);
    await cubit.close();
  });

  test('followRow updates the row + the canonical store (SC-004)', () async {
    final cubit = build();
    await cubit.init('u_alice_travel', FollowConnTab.followers);
    final target = (cubit.state as FollowListLoaded).rows.firstWhere(
      (r) => !r.relationship.following && !r.relationship.requested,
    );
    final ok = await cubit.followRow(target.user.id);
    expect(ok, isTrue);
    final row = (cubit.state as FollowListLoaded).rows.firstWhere(
      (r) => r.user.id == target.user.id,
    );
    expect(
      row.relationship.following || row.relationship.requested,
      isTrue,
    );
    // Canonical store reflects it too.
    final rel = store.current(target.user.id);
    expect(rel?.following ?? rel?.requested, isTrue);
    await cubit.close();
  });

  test('followRow rolls back on failure', () async {
    final cubit = build();
    await cubit.init('u_alice_travel', FollowConnTab.followers);
    final target = (cubit.state as FollowListLoaded).rows.firstWhere(
      (r) => !r.relationship.following && !r.relationship.requested,
    );
    repo.failNextMutation = true;
    final ok = await cubit.followRow(target.user.id);
    expect(ok, isFalse);
    final row = (cubit.state as FollowListLoaded).rows.firstWhere(
      (r) => r.user.id == target.user.id,
    );
    expect(row.relationship.following, isFalse);
    await cubit.close();
  });
}
