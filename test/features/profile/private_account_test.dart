import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/features/profile/domain/usecases/follow_usecases.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/profile_state.dart';

/// #010 T042: private accounts (viewer-side) — gating, request, withdraw,
/// approved access, block invisibility (SC-005).
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

  test('a private, non-approved account is gated with no grid', () async {
    final cubit = build();
    await cubit.loadInitial('carol_private');
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.gated, isTrue);
    expect(loaded.view.showPrivateGate, isTrue);
    expect(loaded.view.canOpenConnections, isFalse);
    expect(loaded.grid, isEmpty); // no gated content leaked
    await cubit.close();
  });

  test('following a private account requests (no content revealed)', () async {
    final cubit = build();
    await cubit.loadInitial('carol_private');
    await cubit.follow();
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.requested, isTrue);
    expect(loaded.grid, isEmpty);
    await cubit.close();
  });

  test('withdrawing a request returns to follow', () async {
    final cubit = build();
    await cubit.loadInitial('carol_private');
    await cubit.follow();
    await cubit.unfollow(); // withdraw
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.relationship.requested, isFalse);
    expect(loaded.view.relationship.following, isFalse);
    await cubit.close();
  });

  test('an approved follower of a private account sees the grid', () async {
    final cubit = build();
    await cubit.loadInitial('dave_private_ok');
    final loaded = cubit.state as ProfileLoaded;
    expect(loaded.view.gated, isFalse);
    expect(loaded.grid, isNotEmpty);
    await cubit.close();
  });

  test('a blocked account is not viewable (SC-005)', () async {
    final cubit = build();
    await cubit.loadInitial('blocked_user');
    expect(cubit.state, isA<ProfileError>());
    await cubit.close();
  });
}
