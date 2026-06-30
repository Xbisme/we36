import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// A stand-in for the real session state (#003). It only toggles a signed-in
/// flag so both navigation zones are reachable for review this spec. The
/// router's redirect reads this; #003 swaps it for the real session source
/// with NO route changes.
@lazySingleton
class AuthGuardStub extends ChangeNotifier {
  /// Default signed-in so the main shell is reviewable on launch (see spec
  /// Assumptions). Toggle to preview the pre-auth flow.
  bool _signedIn = true;

  bool get isSignedIn => _signedIn;

  set isSignedIn(bool value) {
    if (_signedIn == value) return;
    _signedIn = value;
    notifyListeners();
  }

  void toggle() => isSignedIn = !_signedIn;
}
