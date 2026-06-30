import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Pumps [child] inside a MaterialApp with the We36 theme + localizations, at an
/// optional [surfaceSize] (to exercise adaptive breakpoints).
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Size? surfaceSize,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  if (surfaceSize != null) {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}
