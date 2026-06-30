import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/services/session/session_controller.dart';

/// Tracks the current onboarding slide and records that the first-launch intro
/// has been seen (so it never shows again — spec FR-028). Navigation off the
/// last slide (Get started → Sign up / Skip → Sign in) is the page's job.
@injectable
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit(this._session) : super(0);

  final SessionController _session;

  void setPage(int index) => emit(index);

  /// Persist the "already onboarded" flag.
  Future<void> finish() => _session.markOnboardingSeen();
}
