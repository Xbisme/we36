import 'package:flutter/widgets.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

export 'package:we36/l10n/generated/app_localizations.dart';

/// `context.l10n` — the localized strings for the current locale
/// (Constitution XIV). Never hardcode user-facing strings.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
