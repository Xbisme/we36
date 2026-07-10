import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/settings_section_header.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/session/session_controller.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/widgets/about_section.dart';

/// Settings hub (#014 Screen 30, FR-001/002/003/004): grouped list reachable
/// from the profile gear. Rows navigate to child surfaces; About shows the app
/// version; Log out clears the session. Adaptive width handled by the router's
/// `CenteredMobile` wrapper.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showAppDialog(
      context,
      title: l10n.settingsLogOutConfirmTitle,
      body: l10n.settingsLogOutConfirmBody,
      primaryLabel: l10n.settingsLogOutConfirmAction,
      secondaryLabel: l10n.commonCancel,
      destructive: true,
    );
    if (ok) await getIt<SessionController>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;

    void go(String route) => unawaited(context.push(route));

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.settingsTitle,
        large: true,
        onBack: () => context.pop(),
      ),
      body: ListView(
        children: [
          SettingsSectionHeader(l10n.settingsSectionAccount),
          SettingsRow(
            icon: AppIcons.profile,
            label: l10n.settingsEditProfile,
            onTap: () => go(AppRoutes.editProfile),
          ),
          SettingsRow(
            icon: AppIcons.shield,
            label: l10n.settingsTwoFactor,
            onTap: () => go(AppRoutes.settingsTwoFactor),
          ),
          SettingsRow(
            icon: AppIcons.download,
            label: l10n.settingsDataExport,
            onTap: () => go(AppRoutes.settingsDataExport),
          ),

          SettingsSectionHeader(l10n.settingsSectionPrivacy),
          SettingsRow(
            icon: AppIcons.lock,
            label: l10n.settingsPrivacySecurity,
            onTap: () => go(AppRoutes.settingsPrivacy),
          ),
          SettingsRow(
            icon: AppIcons.profile,
            label: l10n.settingsFollowRequests,
            onTap: () => go(AppRoutes.settingsFollowRequests),
          ),
          SettingsRow(
            icon: AppIcons.block,
            label: l10n.settingsBlocked,
            onTap: () => go(AppRoutes.settingsBlocked),
          ),
          SettingsRow(
            icon: AppIcons.closeFriends,
            label: l10n.settingsCloseFriends,
            onTap: () => go(AppRoutes.settingsCloseFriends),
          ),

          SettingsSectionHeader(l10n.settingsSectionNotifications),
          SettingsRow(
            icon: AppIcons.notification,
            label: l10n.settingsNotificationPrefs,
            onTap: () => go(AppRoutes.settingsPrivacy),
          ),

          SettingsSectionHeader(l10n.settingsSectionPreferences),
          SettingsRow(
            icon: AppIcons.language,
            label: l10n.settingsLanguage,
            onTap: () => go(AppRoutes.settingsLanguage),
          ),
          SettingsRow(
            icon: AppIcons.theme,
            label: l10n.settingsTheme,
            onTap: () => go(AppRoutes.settingsTheme),
          ),

          SettingsSectionHeader(l10n.settingsSectionAbout),
          const AboutSection(),

          const SizedBox(height: 24),
          SettingsRow(
            icon: AppIcons.logOut,
            label: l10n.settingsLogOut,
            trailing: SettingsRowTrailing.none,
            destructive: true,
            onTap: () => unawaited(_confirmLogout(context)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
