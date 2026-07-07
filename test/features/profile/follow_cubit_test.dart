import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/profile_state.dart';

/// #010 T031: optimistic follow/unfollow — counts, rollback, idempotency, and
/// canonical store propagation (SC-002/003/004).
void main() {
  late RelationshipStore store;
  late FakeProfileRepository repo;

  ProfileCubit build() => ProfileCubit(
    LoadProfile(repo),
    LoadProfileGrid(repo),
    FollowAction(repo, store),
    store,
  );

  setUp(() {
    store = RelationshipStore();
    repo = FakeProfileRepository(store);
  });

  test('follow a public account → following + follower count +1', () async {
    final cubit = build();
    await cubit.loadInitial('bob_makes');
    final before = (cubit.state as ProfileLoaded).view.user.followersCount;
    final ok = await cubit.follow();
    expect(ok, isTrue);
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.following, isTrue);
    expect(loaded.view.user.followersCount, before + 1);
    await cubit.close();
  });

  test('unfollow reverts following and decrements the count', () async {
    final cubit = build();
    await cubit.loadInitial('erin_verified'); // seeded following
    expect((cubit.state as ProfileLoaded).view.relationship.following, isTrue);
    final before = (cubit.state as ProfileLoaded).view.user.followersCount;
    await cubit.unfollow();
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.following, isFalse);
    expect(loaded.view.user.followersCount, before - 1);
    await cubit.close();
  });

  test('follow a private account → requested (no follower bump)', () async {
    final cubit = build();
    await cubit.loadInitial('carol_private');
    final before = (cubit.state as ProfileLoaded).view.user.followersCount;
    await cubit.follow();
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.requested, isTrue);
    expect(loaded.view.relationship.following, isFalse);
    expect(loaded.view.user.followersCount, before);
    await cubit.close();
  });

  test('a failed follow rolls back relationship + count (SC-002)', () async {
    final cubit = build();
    await cubit.loadInitial('bob_makes');
    final before = (cubit.state as ProfileLoaded).view.user.followersCount;
    repo.failNextMutation = true;
    final ok = await cubit.follow();
    expect(ok, isFalse);
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.following, isFalse);
    expect(loaded.view.user.followersCount, before);
    await cubit.close();
  });

  test(
    'a follow reflects in the canonical store for other watchers (SC-004)',
    () async {
      final cubit = build();
      await cubit.loadInitial('bob_makes');
      await cubit.follow();
      final rel = store.current('u_bob_makes');
      expect(rel?.following, isTrue);
      await cubit.close();
    },
  );

  test(
    'follow is idempotent — a second follow yields one net (SC-003)',
    () async {
      final cubit = build();
      await cubit.loadInitial('bob_makes');
      final before = (cubit.state as ProfileLoaded).view.user.followersCount;
      await cubit.follow();
      await cubit.follow(); // no-op
      final loaded = cubit.state as ProfileLoaded;
      expect(loaded.view.relationship.following, isTrue);
      expect(loaded.view.user.followersCount, before + 1);
      await cubit.close();
    },
  );
}
