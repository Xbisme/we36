import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// About row (#014, FR-004): app version + build, read at runtime via
/// `package_info_plus`. Renders a stable placeholder while resolving so the
/// row never jumps or errors.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final value = info == null
            ? '—'
            : l10n.settingsAboutVersion(info.version, info.buildNumber);
        return SettingsRow(
          icon: AppIcons.info,
          label: l10n.settingsSectionAbout,
          trailing: SettingsRowTrailing.none,
          value: value,
        );
      },
    );
  }
}
