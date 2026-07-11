import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:we36/core/data/moderation/block_actions.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/moderation/fake_block_repository.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/settings/presentation/cubit/blocked_accounts_cubit.dart';
import 'package:we36/features/settings/presentation/pages/blocked_accounts_page.dart';
import 'package:we36/features/settings/presentation/pages/settings_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

BlockedAccountsCubit _blockedCubit() {
  final repo = FakeBlockRepository();
  final blocked = BlockedUsersStore();
  return BlockedAccountsCubit(
    repo,
    BlockActions(repo, RelationshipStore(), blocked),
    blocked,
  );
}

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
    testWidgets('settings row variants golden — $name', (tester) async {
      tester.view.physicalSize = const Size(430, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _host(
          const Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsRow(label: 'Chevron row'),
                SettingsRow(label: 'Value row', value: 'English'),
                SettingsRow(
                  label: 'Toggle on',
                  trailing: SettingsRowTrailing.toggle,
                  switchValue: true,
                ),
                SettingsRow(
                  label: 'Toggle off',
                  trailing: SettingsRowTrailing.toggle,
                ),
                SettingsRow(
                  label: 'Destructive',
                  trailing: SettingsRowTrailing.none,
                  destructive: true,
                ),
              ],
            ),
          ),
          mode,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/settings_row_$name.png'),
      );
    });

    testWidgets('blocked accounts golden — $name', (tester) async {
      tester.view.physicalSize = const Size(430, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _host(
          BlocProvider(
            create: (_) => _blockedCubit(),
            child: const BlockedAccountsPage(),
          ),
          mode,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(BlockedAccountsPage),
        matchesGoldenFile('goldens/blocked_accounts_$name.png'),
      );
    });
    // NOTE: the follow-requests page renders wall-clock relative time
    // ("1d"/"2d") so it's intentionally covered by the deterministic widget
    // test (follow_requests_page_test), not a time-dependent golden.
  }
}
