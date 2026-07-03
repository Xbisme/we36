import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/profile/domain/usecases/edit_profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_state.dart';

/// Drives the edit-profile form (#010 US5): pre-fill, live username availability,
/// avatar upload, and **optimistic** save with rollback.
@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._load, this._check, this._changeAvatar, this._save)
    : super(const EditProfileState.initial());

  final LoadEditForm _load;
  final CheckUsername _check;
  final ChangeAvatar _changeAvatar;
  final SaveProfile _save;

  int _checkToken = 0;

  Future<void> load() async {
    emit(const EditProfileState.loading());
    final res = await _load();
    if (res.isErr) {
      emit(EditProfileState.error(res.failureOrNull!));
      return;
    }
    final me = res.valueOrNull!;
    emit(
      EditProfileState.editing(
        displayName: me.displayName ?? '',
        username: me.username ?? '',
        originalUsername: me.username ?? '',
        pronouns: me.pronouns,
        website: me.website,
        bio: me.bio,
        avatarMediaId: me.avatarMediaId,
      ),
    );
  }

  EditProfileEditing? get _editing =>
      state is EditProfileEditing ? state as EditProfileEditing : null;

  void updateDisplayName(String value) {
    final s = _editing;
    if (s == null) return;
    emit(s.copyWith(displayName: value, dirty: true));
  }

  void updatePronouns(String value) {
    final s = _editing;
    if (s == null) return;
    emit(s.copyWith(pronouns: value, dirty: true));
  }

  void updateWebsite(String value) {
    final s = _editing;
    if (s == null) return;
    emit(s.copyWith(website: value, dirty: true));
  }

  void updateBio(String value) {
    final s = _editing;
    if (s == null) return;
    emit(s.copyWith(bio: value, dirty: true));
  }

  Future<void> updateUsername(String value) async {
    final s = _editing;
    if (s == null) return;
    if (value == s.originalUsername) {
      emit(
        s.copyWith(
          username: value,
          dirty: true,
          usernameStatus: UsernameStatus.idle,
        ),
      );
      return;
    }
    emit(
      s.copyWith(
        username: value,
        dirty: true,
        usernameStatus: UsernameStatus.checking,
      ),
    );
    final token = ++_checkToken;
    final res = await _check(value);
    if (token != _checkToken) return; // superseded
    final current = _editing;
    if (current == null || current.username != value) return;
    emit(
      current.copyWith(
        usernameStatus: res.isErr
            ? UsernameStatus.invalid
            : (res.valueOrNull!
                  ? UsernameStatus.available
                  : UsernameStatus.taken),
      ),
    );
  }

  Future<bool> changeAvatar(Uint8List bytes) async {
    final s = _editing;
    if (s == null) return false;
    emit(s.copyWith(avatarUploading: true));
    final res = await _changeAvatar(bytes);
    final current = _editing;
    if (current == null) return res.isOk;
    if (res.isOk) {
      emit(
        current.copyWith(
          avatarMediaId: res.valueOrNull,
          avatarUploading: false,
          dirty: true,
        ),
      );
      return true;
    }
    // Failure: keep the previous avatar (FR-023).
    emit(current.copyWith(avatarUploading: false));
    return false;
  }

  /// Persist the form. Returns false on failure (the form is left intact).
  Future<bool> save() async {
    final s = _editing;
    if (s == null || !state.canSave) return false;
    emit(s.copyWith(saving: true));
    final res = await _save(
      displayName: s.displayName.trim(),
      username: s.username,
      pronouns: s.pronouns,
      website: s.website,
      bio: s.bio,
      avatarMediaId: s.avatarMediaId,
    );
    final current = _editing;
    if (current == null) return res.isOk;
    if (res.isErr) {
      // Reject a username taken at save (FR-022) or a transient failure.
      final taken = res.failureOrNull is AppFailureConflict;
      emit(
        current.copyWith(
          saving: false,
          usernameStatus: taken ? UsernameStatus.taken : current.usernameStatus,
        ),
      );
      return false;
    }
    emit(current.copyWith(saving: false, dirty: false));
    return true;
  }
}
