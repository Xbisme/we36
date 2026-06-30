import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart';

/// Cubit behind the OAuth buttons (Constitution III, 4-state). On success the
/// `SessionController` routes; on `oauthCancelled` the UI stays silent (FR-021),
/// on `oauthFailed` it shows a toast.
@injectable
class OAuthCubit extends AppCubit<MeProfile> {
  OAuthCubit(this._google, this._apple);

  final SignInWithGoogle _google;
  final SignInWithApple _apple;

  Future<void> google() => run(_google.call);
  Future<void> apple() => run(_apple.call);
}
