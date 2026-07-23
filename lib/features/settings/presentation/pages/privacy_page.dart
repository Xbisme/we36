import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/settings_section_header.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/settings_cubit.dart';

/// Privacy & security (#014 Screen 31, US2/US6): private-account + activity-status
/// toggles + entry to the follow-request inbox. Toggles are optimistic with a
/// toast on rollback.
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  StreamSubscription<AppFailure>? _errorSub;
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final cubit = context.read<SettingsCubit>();
    unawaited(cubit.load());
    _errorSub = cubit.errors.listen((_) {
      if (!mounted) return;
      getIt<ToastService>().show(
        context,
        message: context.l10n.settingsUpdateFailed,
        tone: ToastTone.error,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_errorSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.settingsPrivacySecurity,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<SettingsCubit, AppState<AccountSettings>>(
        builder: (context, state) {
          final settings = state.dataOrNull;
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              SettingsSectionHeader(l10n.settingsSectionPrivacy),
              SettingsRow(
                icon: AppIcons.lock,
                label: l10n.settingsPrivateAccount,
                description: l10n.settingsPrivateAccountDesc,
                tone: SettingsRowTone.rose,
                trailing: SettingsRowTrailing.toggle,
                switchValue: settings.isPrivate,
                onSwitchChanged: (v) => cubit.setPrivate(value: v),
              ),
              SettingsRow(
                icon: AppIcons.profile,
                label: l10n.settingsFollowRequests,
                onTap: () =>
                    unawaited(context.push(AppRoutes.settingsFollowRequests)),
              ),
              SettingsRow(
                icon: AppIcons.activity,
                label: l10n.settingsActivityStatus,
                description: l10n.settingsActivityStatusDesc,
                trailing: SettingsRowTrailing.toggle,
                switchValue: settings.activityStatusVisible,
                onSwitchChanged: (v) => cubit.setActivityStatus(value: v),
              ),
            ],
          );
        },
      ),
    );
  }
}
