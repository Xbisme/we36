import 'package:injectable/injectable.dart';

/// The core seam for reciprocal activity-status visibility (#014, US6, FR-028).
/// `SettingsCubit` writes it when the toggle changes; messaging reads it to
/// suppress presence/typing both ways when the user has turned activity status
/// off — without `features/messaging` importing `features/settings`
/// (Constitution XI). Defaults to visible.
@lazySingleton
class PresenceVisibility {
  bool visible = true;
}
