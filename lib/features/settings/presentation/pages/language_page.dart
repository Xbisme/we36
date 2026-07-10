import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';

/// Language selector (#014 US5, FR-024/025): English / Vietnamese / System.
/// Device-scoped; applied immediately via `AppSettingsCubit`.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<AppSettingsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.settingsLanguage,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final code = state.locale?.languageCode;
          Widget option(String label, String? value) => SettingsRow(
            label: label,
            icon: code == value ? AppIcons.check : null,
            trailing: SettingsRowTrailing.none,
            onTap: () => cubit.setLocale(value == null ? null : Locale(value)),
          );
          return ListView(
            children: [
              option(l10n.settingsSystemDefault, null),
              option(l10n.settingsLanguageEnglish, 'en'),
              option(l10n.settingsLanguageVietnamese, 'vi'),
            ],
          );
        },
      ),
    );
  }
}
