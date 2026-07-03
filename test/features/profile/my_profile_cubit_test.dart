import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/data/profile/fake_profile_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_state.dart';

/// #010 T023: own-profile cubit — load, tab switch, pagination, error.
class _StubMeRepo implements MeRepository {
  _StubMeRepo(this._profile);
  MeProfile _profile;
  final _controller = StreamController<MeProfile?>.broadcast();

  @override
  Future<Result<MeProfile>> getMe() async {
    _controller.add(_profile);
    return Result.ok(_profile);
  }

  @override
  Stream<MeProfile?> watchMe() => _controller.stream;

  @override
  Future<Result<MeProfile>> setupProfile({
    required String username,
    required String displayName,
    String? bio,
  }) async => Result.ok(_profile);

  @override
  Future<Result<MeProfile>> updateProfile({
    String? displayName,
    String? username,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
  }) async {
    _profile = _profile.copyWith(website: website ?? _profile.website);
    _controller.add(_profile);
    return Result.ok(_profile);
  }
}

void main() {
  late RelationshipStore store;
  late FakeProfileRepository repo;
  late _StubMeRepo me;

  final demoProfile = MeProfile(
    id: 'u_demo',
    email: 'demo@we36.app',
    isPrivate: false,
    isVerified: false,
    profileCompleted: true,
    createdAt: DateTime.utc(2026),
    username: 'demo',
    displayName: 'You',
    website: 'https://we36.app',
  );

  MyProfileCubit build() => MyProfileCubit(
    WatchMe(me),
    FetchMe(me),
    LoadProfile(repo),
    LoadProfileGrid(repo),
  );

  setUp(() {
    store = RelationshipStore();
    repo = FakeProfileRepository(store);
    me = _StubMeRepo(demoProfile);
  });

  test('loadInitial renders the own header + posts grid', () async {
    final cubit = build();
    await cubit.loadInitial();
    final state = cubit.state;
    expect(state, isA<MyProfileLoaded>());
    final loaded = state as MyProfileLoaded;
    expect(loaded.view.isMe, isTrue);
    expect(loaded.view.user.username, 'demo');
    expect(loaded.website, 'https://we36.app');
    expect(loaded.tab, ProfileTab.posts);
    expect(loaded.grid, isNotEmpty);
    await cubit.close();
  });

  test('switchTab loads the tagged grid', () async {
    final cubit = build();
    await cubit.loadInitial();
    await cubit.switchTab(ProfileTab.tagged);
    final loaded = cubit.state as MyProfileLoaded;
    expect(loaded.tab, ProfileTab.tagged);
    expect(loaded.grid, isNotEmpty);
    await cubit.close();
  });

  test('loadMore appends the next page without duplicates', () async {
    final cubit = build();
    await cubit.loadInitial();
    final first = (cubit.state as MyProfileLoaded).grid.length;
    await cubit.loadMore();
    final grid = (cubit.state as MyProfileLoaded).grid;
    expect(grid.length, greaterThanOrEqualTo(first));
    expect(grid.map((e) => e.id).toSet().length, grid.length);
    await cubit.close();
  });

  test('a failed profile load surfaces an error', () async {
    repo.failNextQuery = true;
    final cubit = build();
    await cubit.loadInitial();
    expect(cubit.state, isA<MyProfileError>());
    await cubit.close();
  });
}
