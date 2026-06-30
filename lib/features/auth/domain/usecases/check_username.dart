import 'package:injectable/injectable.dart';
import 'package:we36/core/data/auth/auth_repository.dart';
import 'package:we36/core/data/auth/dto/check_username.dart';
import 'package:we36/core/domain/result.dart';

/// Live username availability check for Profile setup (case-insensitive + format
/// validation on the backend). Called debounced as the user types.
@injectable
class CheckUsername {
  const CheckUsername(this._auth);

  final AuthRepository _auth;

  Future<Result<UsernameAvailability>> call(String username) =>
      _auth.checkUsername(username: username);
}
