import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// App root: fixed light/dark themes + follow-system, full EN/VI localization,
/// and the injected router. No color-scheme picker (Constitution VI).
class We36App extends StatelessWidget {
  const We36App({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // themeMode defaults to ThemeMode.system — light/dark/follow-system only.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
