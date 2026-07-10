import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// App root: fixed light/dark themes + the user's appearance/language selection
/// (#014, device-scoped) and the injected router. No color-scheme picker
/// (Constitution VI) — only light/dark/system.
class We36App extends StatelessWidget {
  const We36App({required this.router, required this.appSettings, super.key});

  final GoRouter router;
  final AppSettingsCubit appSettings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppSettingsCubit>.value(
      value: appSettings,
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            // Null → follow the device locale (with English fallback for an
            // unsupported system language, FR-025).
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
