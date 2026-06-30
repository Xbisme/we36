import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/auth/domain/usecases/sign_up.dart';

/// Cubit for the Sign up screen (Constitution III, 4-state). Pre-validates email
/// + password (≥ 8) client-side, then registers. On success the
/// `SessionController` routes to Profile setup; the screen reacts only to
/// `loading` and `error` (e.g. `conflict` for a duplicate email).
@injectable
class SignUpCubit extends AppCubit<MeProfile> {
  SignUpCubit(this._signUp);

  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final SignUp _signUp;

  Future<void> submit({required String email, required String password}) async {
    final fields = <String, String>{};
    if (!_emailRe.hasMatch(email.trim())) fields['email'] = 'invalid';
    if (password.length < 8) fields['password'] = 'tooShort';
    if (fields.isNotEmpty) {
      emitError(AppFailure.validation(fields: fields));
      return;
    }
    await run(() => _signUp(email.trim(), password));
  }
}
