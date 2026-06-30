import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/features/auth/domain/usecases/check_username.dart';
import 'package:we36/features/auth/domain/usecases/setup_profile.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_state.dart';

/// Drives Profile setup: a debounced live username availability check plus the
/// setup submission. Username is format-validated client-side before the network
/// check (meets SC-006 without spamming the endpoint).
@injectable
class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit(this._check, this._setup)
    : super(const ProfileSetupState());

  static final RegExp _formatRe = RegExp(
    r'^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$',
  );

  final CheckUsername _check;
  final SetupProfile _setup;
  Timer? _debounce;

  void onUsernameChanged(String raw) {
    _debounce?.cancel();
    final username = raw.trim().toLowerCase();
    if (username.isEmpty) {
      emit(state.copyWith(username: UsernameStatus.empty));
      return;
    }
    if (!_formatRe.hasMatch(username)) {
      emit(state.copyWith(username: UsernameStatus.invalid));
      return;
    }
    emit(state.copyWith(username: UsernameStatus.checking));
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final result = await _check(username);
      if (isClosed) return;
      final status = result.fold(
        (a) => a.available
            ? UsernameStatus.available
            : a.reason == UsernameReason.invalid
            ? UsernameStatus.invalid
            : UsernameStatus.taken,
        (_) => UsernameStatus.invalid,
      );
      emit(state.copyWith(username: status));
    });
  }

  Future<void> submit({
    required String username,
    required String displayName,
    String? bio,
  }) async {
    emit(state.copyWith(submitting: true));
    final result = await _setup(
      username: username.trim().toLowerCase(),
      displayName: displayName.trim(),
      bio: bio?.trim(),
    );
    if (isClosed) return;
    // On success the SessionController routes to Home; surface failures inline.
    result.fold(
      (_) {},
      (failure) =>
          emit(state.copyWith(submitting: false, submitError: failure)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
