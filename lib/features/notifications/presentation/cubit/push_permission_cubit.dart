import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/services/push/push_service.dart';

/// Drives the push-permission affordance on the Activity screen (#013 US2). The
/// state is the current [PushPermissionStatus]: an affordance (value explainer)
/// is shown while not `granted`; tapping it triggers the OS prompt via [request].
/// We never auto-prompt or re-nag — the person opts in from the affordance
/// (FR-014/FR-019). Device registration happens automatically once granted (the
/// token flows through `PushRegistrationService`).
@injectable
class PushPermissionCubit extends Cubit<PushPermissionStatus> {
  PushPermissionCubit(this._push) : super(PushPermissionStatus.notDetermined);

  final PushService _push;

  /// Read the current status on Activity open (no prompt).
  Future<void> ensure() async => emit(await _push.currentStatus());

  /// Show the OS permission prompt (from the affordance tap).
  Future<void> request() async => emit(await _push.requestPermission());

  /// Whether to show the "turn on notifications" affordance.
  bool get showAffordance => state != PushPermissionStatus.granted;
}
