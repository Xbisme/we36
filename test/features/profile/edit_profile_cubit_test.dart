import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/features/profile/domain/usecases/edit_profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_state.dart';

/// #010 T048: edit cubit — prefill, username status, save + rollback, avatar.
class _MockCheck extends Mock implements CheckUsername {}

class _StubMeRepo implements MeRepository {
  _StubMeRepo(this._profile);
  MeProfile _profile;
  bool failSave = false;
  final _controller = StreamController<MeProfile?>.broadcast();

  @override
  Future<Result<MeProfile>> getMe() async => Result.ok(_profile);
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
    if (failSave) return const Result.err(AppFailure.conflict());
    _profile = _profile.copyWith(
      displayName: displayName ?? _profile.displayName,
    );
    return Result.ok(_profile);
  }
}

void main() {
  late _StubMeRepo me;
  late _MockCheck check;
  late FakeMediaUploadService uploader;

  final profile = MeProfile(
    id: 'u_demo',
    email: 'demo@we36.app',
    isPrivate: false,
    isVerified: false,
    profileCompleted: true,
    createdAt: DateTime.utc(2026),
    username: 'demo',
    displayName: 'Demo',
    bio: 'hi',
  );

  EditProfileCubit build() => EditProfileCubit(
    LoadEditForm(me),
    check,
    ChangeAvatar(uploader),
    SaveProfile(me),
  );

  setUp(() {
    me = _StubMeRepo(profile);
    check = _MockCheck();
    uploader = FakeMediaUploadService();
    when(
      () => check.call(any()),
    ).thenAnswer((_) async => const Result.ok(true));
  });

  test('load pre-fills the form', () async {
    final cubit = build();
    await cubit.load();
    final s = cubit.state as EditProfileEditing;
    expect(s.displayName, 'Demo');
    expect(s.username, 'demo');
    expect(s.usernameStatus, UsernameStatus.idle);
    await cubit.close();
  });

  test('unchanged username stays idle; a taken one blocks save', () async {
    final cubit = build();
    await cubit.load();
    await cubit.updateUsername('demo'); // unchanged
    expect(
      (cubit.state as EditProfileEditing).usernameStatus,
      UsernameStatus.idle,
    );
    when(
      () => check.call('taken_one'),
    ).thenAnswer((_) async => const Result.ok(false));
    await cubit.updateUsername('taken_one');
    final s = cubit.state as EditProfileEditing;
    expect(s.usernameStatus, UsernameStatus.taken);
    expect(cubit.state.canSave, isFalse);
    await cubit.close();
  });

  test(
    'editing a field enables save; save persists and clears dirty',
    () async {
      final cubit = build();
      await cubit.load();
      cubit.updateDisplayName('Demo Two');
      expect(cubit.state.canSave, isTrue);
      final ok = await cubit.save();
      expect(ok, isTrue);
      expect((cubit.state as EditProfileEditing).dirty, isFalse);
      await cubit.close();
    },
  );

  test('a failed save keeps the form intact and returns false', () async {
    final cubit = build();
    await cubit.load();
    cubit.updateDisplayName('Demo Two');
    me.failSave = true;
    final ok = await cubit.save();
    expect(ok, isFalse);
    final s = cubit.state as EditProfileEditing;
    expect(s.displayName, 'Demo Two'); // intact
    expect(s.saving, isFalse);
    await cubit.close();
  });

  test(
    'changeAvatar sets the media id; a failure keeps the previous',
    () async {
      final cubit = build();
      await cubit.load();
      final okRes = await cubit.changeAvatar(Uint8List(8));
      expect(okRes, isTrue);
      expect((cubit.state as EditProfileEditing).avatarMediaId, isNotNull);

      uploader.failAfterFraction = 0.1;
      final prev = (cubit.state as EditProfileEditing).avatarMediaId;
      final failRes = await cubit.changeAvatar(Uint8List(8));
      expect(failRes, isFalse);
      expect((cubit.state as EditProfileEditing).avatarMediaId, prev);
      await cubit.close();
    },
  );
}
