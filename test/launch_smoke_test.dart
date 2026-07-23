import 'package:flutter_test/flutter_test.dart';
import 'package:we36/app/app.dart';
import 'package:we36/bootstrap.dart';
import 'package:we36/core/config/app_config.dart';

void main() {
  testWidgets(
    'bootstrap() boots the app (DI + error hooks, no zone mismatch)',
    (tester) async {
      // Hermetic: boot the fake DI graph (zero-network) regardless of the
      // dev/prod default of 'real'.
      await bootstrap(
        const AppConfig(
          flavor: Flavor.dev,
          appName: 'We36 Dev',
          bundleId: 'app.we36.dev',
          diEnvironment: 'fake',
        ),
      );
      // The splash shows a perpetual loading spinner (design), so pumpAndSettle
      // never settles — pump a bounded couple of frames instead.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(We36App), findsOneWidget);
    },
  );
}
