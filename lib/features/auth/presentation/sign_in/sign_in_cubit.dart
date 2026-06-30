import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/auth/domain/usecases/sign_in.dart';

/// Cubit for the Sign in screen (Constitution III, 4-state). Pre-validates the
/// email + password client-side (→ `validation` failure mapped to inline field
/// errors), then submits. On success the `SessionController` drives navigation,
/// so the screen only reacts to `loading` (submitting) and `error`.
@injectable
class SignInCubit extends AppCubit<MeProfile> {
  SignInCubit(this._signIn);

  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final SignIn _signIn;

  Future<void> submit({required String email, required String password}) async {
    final fields = <String, String>{};
    if (!_emailRe.hasMatch(email.trim())) fields['email'] = 'invalid';
    if (password.length < 8) fields['password'] = 'tooShort';
    if (fields.isNotEmpty) {
      emitError(AppFailure.validation(fields: fields));
      return;
    }
    await run(() => _signIn(email.trim(), password));
  }
}
