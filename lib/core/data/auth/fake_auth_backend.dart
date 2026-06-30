import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/data/auth/dto/session.dart';
import 'package:we36/core/data/me/me_profile.dart';

/// Shared in-memory account store for the `fake` environment (#003): backs both
/// `FakeAuthRepository` and `FakeMeRepository` so the whole auth flow runs with
/// zero network (Constitution VIII/XII). Seeds one demo account so US1 sign-in is
/// demoable; fake tokens encode the account email so a persisted session can be
/// resolved back to its profile after an app restart (finding I1).
@LazySingleton(env: ['fake'])
class FakeAuthBackend {
  FakeAuthBackend() {
    _seedDemo();
  }

  static const String demoEmail = 'demo@we36.app';
  static const String demoPassword = 'password123';

  /// The fixed OTP returned/accepted in fake mode (mirrors the dev `devCode`).
  static const String fakeOtp = '123456';

  static final RegExp _usernameRe = RegExp(
    r'^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$',
  );

  final Uuid _uuid = const Uuid();
  final Map<String, _Account> _byEmail = {};
  final Set<String> _takenUsernames = {'demo', 'admin', 'we36'};

  void _seedDemo() {
    final profile = MeProfile(
      id: _uuid.v7(),
      email: demoEmail,
      username: 'demo',
      displayName: 'Demo',
      isPrivate: false,
      isVerified: true,
      profileCompleted: true,
      createdAt: DateTime.utc(2026),
      bio: 'The We36 demo account.',
    );
    _byEmail[demoEmail] = _Account(password: demoPassword, profile: profile);
  }

  // --- token helpers (fake tokens carry the account email) ---

  Session _session(String email) => Session(
    accessToken: 'fake-access.$email',
    refreshToken: 'fake-refresh.$email',
    expiresIn: 900,
  );

  String? emailFromToken(String? token) {
    if (token == null) return null;
    final i = token.indexOf('.');
    return i < 0 ? null : token.substring(i + 1);
  }

  MeProfile? profileForToken(String? token) =>
      _byEmail[emailFromToken(token)]?.profile;

  // --- auth operations ---

  /// null email collision → caller maps to a CONFLICT failure.
  Session? register(String email, String password) {
    if (_byEmail.containsKey(email)) return null;
    final profile = MeProfile(
      id: _uuid.v7(),
      email: email,
      isPrivate: false,
      isVerified: false,
      profileCompleted: false,
      createdAt: DateTime.utc(2026),
    );
    _byEmail[email] = _Account(password: password, profile: profile);
    return _session(email);
  }

  /// null → invalid credentials.
  Session? login(String email, String password) {
    final account = _byEmail[email];
    if (account == null || account.password != password) return null;
    return _session(email);
  }

  Session oauthLink(String email) {
    _byEmail.putIfAbsent(
      email,
      () => _Account(
        password: null,
        profile: MeProfile(
          id: _uuid.v7(),
          email: email,
          isPrivate: false,
          isVerified: false,
          profileCompleted: false,
          createdAt: DateTime.utc(2026),
        ),
      ),
    );
    return _session(email);
  }

  bool resetPassword(String email, String code, String newPassword) {
    if (code != fakeOtp) return false;
    final account = _byEmail[email];
    if (account != null) {
      _byEmail[email] = account.copyWith(password: newPassword);
    }
    return true;
  }

  ({bool available, String? reason}) checkUsername(String username) {
    if (!_usernameRe.hasMatch(username)) {
      return (available: false, reason: 'invalid');
    }
    if (_takenUsernames.contains(username.toLowerCase())) {
      return (available: false, reason: 'taken');
    }
    return (available: true, reason: null);
  }

  /// Apply profile setup to the account behind [token]; returns the saved profile.
  MeProfile? setupProfile(
    String? token, {
    required String username,
    required String displayName,
    String? bio,
  }) {
    final email = emailFromToken(token);
    final account = email == null ? null : _byEmail[email];
    if (account == null) return null;
    final updated = account.profile.copyWith(
      username: username,
      displayName: displayName,
      bio: bio,
      profileCompleted: true,
    );
    _byEmail[email!] = account.copyWith(profile: updated);
    _takenUsernames.add(username.toLowerCase());
    return updated;
  }
}

class _Account {
  const _Account({required this.password, required this.profile});

  final String? password;
  final MeProfile profile;

  _Account copyWith({String? password, MeProfile? profile}) => _Account(
    password: password ?? this.password,
    profile: profile ?? this.profile,
  );
}
