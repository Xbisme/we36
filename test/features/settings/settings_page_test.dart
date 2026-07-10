import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:we36/core/presentation/settings_row.dart';
import 'package:we36/core/presentation/settings_section_header.dart';
import 'package:we36/features/settings/presentation/pages/settings_page.dart';

import '../../helpers/pump_app.dart';

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

  group('SettingsPage (US1)', () {
    testWidgets('renders the grouped sections', (tester) async {
      await pumpApp(
        tester,
        const SettingsPage(),
        surfaceSize: const Size(400, 2400),
      );
      await tester.pumpAndSettle();

      // Section headers are upper-cased in SettingsSectionHeader.
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('PRIVACY'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.byType(SettingsSectionHeader), findsNWidgets(5));
    });

    testWidgets('renders key rows + About version + Log out', (tester) async {
      await pumpApp(
        tester,
        const SettingsPage(),
        surfaceSize: const Size(400, 2400),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Privacy & security'), findsOneWidget);
      expect(find.text('Blocked accounts'), findsOneWidget);
      expect(find.text('Close friends'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      // About row resolves the mocked package version.
      expect(find.text('Version 1.0.0 (42)'), findsOneWidget);

      // Destructive log-out row present.
      expect(find.text('Log out'), findsOneWidget);
      expect(find.byType(SettingsRow), findsWidgets);
    });
  });
}
