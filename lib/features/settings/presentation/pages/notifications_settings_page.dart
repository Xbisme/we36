import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/data/settings/account_settings.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/settings_section_header.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/settings_cubit.dart';

/// Notification preferences (#014): on/off toggles per activity type + pause-all,
/// optimistic via `SettingsCubit` (PATCH `/me/settings` notifications).
class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
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
        title: l10n.settingsNotificationPrefs,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<SettingsCubit, AppState<AccountSettings>>(
        builder: (context, state) {
          final settings = state.dataOrNull;
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final n = settings.notifications;
          void update(NotificationPrefs next) =>
              unawaited(cubit.setNotifications(next));

          return ListView(
            children: [
              SettingsRow(
                label: l10n.notifPrefPauseAll,
                description: l10n.notifPrefPauseAllDesc,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.globalMute,
                onSwitchChanged: (v) => update(n.copyWith(globalMute: v)),
              ),
              SettingsSectionHeader(l10n.settingsSectionNotifications),
              SettingsRow(
                label: l10n.notifPrefLikes,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.likes,
                onSwitchChanged: (v) => update(n.copyWith(likes: v)),
              ),
              SettingsRow(
                label: l10n.notifPrefComments,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.comments,
                onSwitchChanged: (v) => update(n.copyWith(comments: v)),
              ),
              SettingsRow(
                label: l10n.notifPrefMentions,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.mentions,
                onSwitchChanged: (v) => update(n.copyWith(mentions: v)),
              ),
              SettingsRow(
                label: l10n.notifPrefFollows,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.follows,
                onSwitchChanged: (v) => update(n.copyWith(follows: v)),
              ),
              SettingsRow(
                label: l10n.notifPrefFollowRequests,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.followRequests,
                onSwitchChanged: (v) => update(n.copyWith(followRequests: v)),
              ),
              SettingsRow(
                label: l10n.notifPrefDirectMessages,
                trailing: SettingsRowTrailing.toggle,
                switchValue: n.directMessages,
                onSwitchChanged: (v) => update(n.copyWith(directMessages: v)),
              ),
            ],
          );
        },
      ),
    );
  }
}
