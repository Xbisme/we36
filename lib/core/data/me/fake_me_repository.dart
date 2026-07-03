import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/fake_auth_backend.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/token_store.dart';

/// In-memory [MeRepository] (`fake` env): resolves the current user from the
/// [FakeAuthBackend] via the access token in the [TokenStore], so a persisted
/// fake session restores its profile after restart (finding I1).
@LazySingleton(as: MeRepository, env: ['fake'])
class FakeMeRepository implements MeRepository {
  FakeMeRepository(this._backend, this._tokenStore);

  final FakeAuthBackend _backend;
  final TokenStore _tokenStore;
  final StreamController<MeProfile?> _controller =
      StreamController<MeProfile?>.broadcast();

  /// Local edits applied by [updateProfile] (session-scoped; the fake backend
  /// stores only setup fields, so #010 edits are held here).
  MeProfile? _override;

  MeProfile? _resolve() {
    final base = _backend.profileForToken(_tokenStore.accessToken);
    if (base == null) return null;
    final o = _override;
    return (o != null && o.id == base.id) ? o : base;
  }

  @override
  Future<Result<MeProfile>> getMe() async {
    final profile = _resolve();
    if (profile == null) {
      return const Result.err(AppFailure.unauthenticated());
    }
    _controller.add(profile);
    return Result.ok(profile);
  }

  @override
  Stream<MeProfile?> watchMe() => _controller.stream;

  @override
  Future<Result<MeProfile>> setupProfile({
    required String username,
    required String displayName,
    String? bio,
  }) async {
    final profile = _backend.setupProfile(
      _tokenStore.accessToken,
      username: username,
      displayName: displayName,
      bio: bio,
    );
    if (profile == null) {
      return const Result.err(AppFailure.unauthenticated());
    }
    _controller.add(profile);
    return Result.ok(profile);
  }

  @override
  Future<Result<MeProfile>> updateProfile({
    String? displayName,
    String? username,
    String? pronouns,
    String? website,
    String? bio,
    String? avatarMediaId,
  }) async {
    final current = _resolve();
    if (current == null) {
      return const Result.err(AppFailure.unauthenticated());
    }
    final updated = current.copyWith(
      displayName: displayName ?? current.displayName,
      username: username ?? current.username,
      pronouns: pronouns ?? current.pronouns,
      website: website ?? current.website,
      bio: bio ?? current.bio,
      avatarMediaId: avatarMediaId ?? current.avatarMediaId,
    );
    _override = updated;
    _controller.add(updated);
    return Result.ok(updated);
  }
}
