import 'package:flutter_test/flutter_test.dart';
import 'package:we36/app/app.dart';
import 'package:we36/bootstrap.dart';
import 'package:we36/core/config/app_config.dart';

void main() {
  testWidgets(
    'bootstrap() boots the app (DI + error hooks, no zone mismatch)',
    (tester) async {
      await bootstrap(const AppConfig.dev());
      await tester.pumpAndSettle();
      expect(find.byType(We36App), findsOneWidget);
    },
  );
}
