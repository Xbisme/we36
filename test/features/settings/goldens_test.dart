import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:we36/core/data/social/fake_follow_requests_repository.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/settings/presentation/cubit/follow_requests_cubit.dart';
import 'package:we36/features/settings/presentation/pages/follow_requests_page.dart';
import 'package:we36/features/settings/presentation/pages/settings_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #014 T066: golden coverage for the settings surface in light + dark.
Widget _host(Widget child, ThemeMode mode) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: mode,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'We36',
      packageName: 'app.we36.dev',
      version: '1.0.0',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  for (final (name, mode) in [
    ('light', ThemeMode.light),
    ('dark', ThemeMode.dark),
  ]) {
    testWidgets('settings hub golden — $name', (tester) async {
      tester.view.physicalSize = const Size(430, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_host(const SettingsPage(), mode));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SettingsPage),
        matchesGoldenFile('goldens/settings_hub_$name.png'),
      );
    });

    testWidgets('follow requests golden — $name', (tester) async {
      tester.view.physicalSize = const Size(430, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _host(
          BlocProvider(
            create: (_) => FollowRequestsCubit(FakeFollowRequestsRepository()),
            child: const FollowRequestsPage(),
          ),
          mode,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(FollowRequestsPage),
        matchesGoldenFile('goldens/follow_requests_$name.png'),
      );
    });
  }
}
