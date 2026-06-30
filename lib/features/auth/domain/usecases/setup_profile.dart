import 'package:injectable/injectable.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/session_controller.dart';

/// First-run profile setup: save username + display name (+ optional bio), then
/// update the `SessionController` so `profileCompleted` flips and the router
/// routes from Profile setup to Home (spec FR-025/FR-027).
@injectable
class SetupProfile {
  const SetupProfile(this._me, this._session);

  final MeRepository _me;
  final SessionController _session;

  Future<Result<MeProfile>> call({
    required String username,
    required String displayName,
    String? bio,
  }) async {
    final result = await _me.setupProfile(
      username: username,
      displayName: displayName,
      bio: bio,
    );
    if (result.isOk) await _session.applyProfile(result.valueOrNull!);
    return result;
  }
}
