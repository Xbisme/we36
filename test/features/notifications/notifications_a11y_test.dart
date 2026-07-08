import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/push/fake_push_service.dart';
import 'package:we36/core/services/push/push_models.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:we36/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:we36/features/notifications/presentation/cubit/push_permission_cubit.dart';
import 'package:we36/features/notifications/presentation/notifications_page.dart';
import 'package:we36/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/notifications_test_doubles.dart';

/// #013 US6 T051: the Activity surface is inclusive + adaptive.
void main() {
  Widget host({double textScale = 1.0}) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationsCubit>.value(
              value: StubNotificationsCubit(
                NotificationsState.loaded(sections: stubSections()),
              ),
            ),
            BlocProvider<PushPermissionCubit>(
              create: (_) => PushPermissionCubit(
                FakePushService()
                  ..scriptedStatus = PushPermissionStatus.granted,
              ),
            ),
          ],
          child: const NotificationsPage(),
        ),
      ),
    ),
  );

  testWidgets('rows expose button semantics with a label', (tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host());
    await tester.pump();

    final semantics = tester.getSemantics(
      find.byType(NotificationTile).first,
    );
    expect(semantics.label, contains('liked your post'));
  });

  testWidgets('renders at 2x text scale without overflow', (tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host(textScale: 2));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reflows on a tablet width', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(host());
    await tester.pump();
    expect(find.byType(NotificationTile), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
