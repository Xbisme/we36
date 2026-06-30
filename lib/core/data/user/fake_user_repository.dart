import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/data/user/user_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Default #002 [UserRepository]: synthesizes deterministic, contract-shaped
/// users entirely in memory (no network), so the app builds, runs, and tests
/// offline (Constitution VIII/XII). Replaced by `UserRepositoryImpl` (cache +
/// remote) when running against a backend.
@LazySingleton(as: UserRepository, env: ['fake'])
class FakeUserRepository implements UserRepository {
  FakeUserRepository() : _uuid = const Uuid();

  final Uuid _uuid;
  final Map<String, User> _users = {};
  final Map<String, StreamController<User?>> _streams = {};

  User _synthesize(String username) => _users.putIfAbsent(
    username,
    () => User(
      id: _uuid.v7(),
      username: username,
      displayName: _displayName(username),
      isPrivate: false,
      isVerified: username.length.isEven,
      followersCount: 128,
      followingCount: 76,
      postsCount: 24,
      bio: 'Hi, I am @$username on We36.',
    ),
  );

  StreamController<User?> _streamFor(String username) =>
      _streams.putIfAbsent(username, StreamController<User?>.broadcast);

  @override
  Future<Result<User>> getByUsername(String username) async {
    final user = _synthesize(username);
    _streamFor(username).add(user);
    return Result<User>.ok(user);
  }

  @override
  Stream<User?> watchByUsername(String username) => _streamFor(username).stream;

  static String _displayName(String username) => username.isEmpty
      ? username
      : '${username[0].toUpperCase()}${username.substring(1)}';
}
