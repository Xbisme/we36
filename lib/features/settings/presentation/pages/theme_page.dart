import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';

/// Appearance selector (#014 US5, FR-026/027): Light / Dark / System. The colour
/// palette is fixed (Constitution VI) — only the mode changes.
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<AppSettingsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.settingsTheme,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          Widget option(String label, ThemeMode mode) => SettingsRow(
            label: label,
            icon: state.themeMode == mode ? AppIcons.check : null,
            trailing: SettingsRowTrailing.none,
            onTap: () => cubit.setThemeMode(mode),
          );
          return ListView(
            children: [
              option(l10n.settingsSystemDefault, ThemeMode.system),
              option(l10n.settingsThemeLight, ThemeMode.light),
              option(l10n.settingsThemeDark, ThemeMode.dark),
            ],
          );
        },
      ),
    );
  }
}
