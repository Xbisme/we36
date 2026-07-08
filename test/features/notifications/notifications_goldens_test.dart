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
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/notifications_test_doubles.dart';

/// #013 US1 T027: Activity feed goldens (light + dark). Network-free stub keeps
/// them deterministic.
void main() {
  Widget host(ThemeData theme) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsCubit>.value(
          value: StubNotificationsCubit(
            NotificationsState.loaded(sections: stubSections()),
          ),
        ),
        BlocProvider<PushPermissionCubit>(
          create: (_) => PushPermissionCubit(
            FakePushService()..scriptedStatus = PushPermissionStatus.granted,
          ),
        ),
      ],
      child: const NotificationsPage(),
    ),
  );

  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    testWidgets('activity feed golden ($name)', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(host(theme));
      await tester.pump();

      await expectLater(
        find.byType(NotificationsPage),
        matchesGoldenFile('goldens/activity_feed_$name.png'),
      );
    });
  }
}
