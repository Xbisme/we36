import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/data/settings/settings_repository.dart';
import 'package:we36/core/domain/app_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/preferences/presence_visibility.dart';

/// Drives the account settings surface (#014, US2/US6). Loads the settings model
/// and applies **optimistic** toggles (private account, activity status) with
/// rollback on failure; failures are surfaced on [errors] for the page to toast.
@injectable
class SettingsCubit extends AppCubit<AccountSettings> {
  SettingsCubit(this._repo, this._presence);

  final SettingsRepository _repo;
  final PresenceVisibility _presence;
  final StreamController<AppFailure> _errors =
      StreamController<AppFailure>.broadcast();

  /// Transient failures from a rolled-back optimistic toggle (page → toast).
  Stream<AppFailure> get errors => _errors.stream;

  Future<void> load() async {
    await run(_repo.getSettings);
    final settings = state.dataOrNull;
    if (settings != null) _presence.visible = settings.activityStatusVisible;
  }

  Future<void> setPrivate({required bool value}) => _optimistic(
    (s) => s.copyWith(isPrivate: value),
    () => _repo.setPrivate(isPrivate: value),
  );

  Future<void> setActivityStatus({required bool value}) {
    // Reflect immediately in the core seam so messaging hides presence both
    // ways without waiting for the next server frame (reciprocal, FR-028).
    _presence.visible = value;
    return _optimistic(
      (s) => s.copyWith(activityStatusVisible: value),
      () => _repo.setActivityStatus(visible: value),
    );
  }

  Future<void> _optimistic(
    AccountSettings Function(AccountSettings current) mutate,
    Future<Result<AccountSettings>> Function() call,
  ) async {
    final current = state.dataOrNull;
    if (current == null) return;
    emitLoaded(mutate(current));
    final result = await call();
    if (isClosed) return;
    result.fold(emitLoaded, (failure) {
      emitLoaded(current); // rollback
      _errors.add(failure);
    });
  }

  @override
  Future<void> close() {
    unawaited(_errors.close());
    return super.close();
  }
}
