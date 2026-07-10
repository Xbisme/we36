import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/domain/app_failure.dart';
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

/// #013 US1 T026: the Activity feed renders sectioned, grouped rows + empty +
/// error states — driven by a seeded stub cubit (no real drift/socket/Firebase
/// inside testWidgets — the #009 gate learning).
void main() {
  Widget host(NotificationsState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsCubit>.value(
          value: StubNotificationsCubit(state),
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

  testWidgets('renders section headers + grouped "and N others"', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      host(NotificationsState.loaded(sections: stubSections())),
    );
    await tester.pump();

    expect(find.text('New'), findsOneWidget);
    expect(find.text('Earlier'), findsOneWidget);
    expect(find.byType(NotificationTile), findsNWidgets(3));
    // Grouped like: "and 4 others" (actorCount 5). Text lives in a RichText.
    expect(
      find.textContaining('and 4 others', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('liked your post', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('started following you', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('shows the empty state when there are no sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const NotificationsState.loaded(sections: [])),
    );
    await tester.pump();
    expect(find.text('No activity yet'), findsOneWidget);
  });

  testWidgets('shows an error + retry state', (tester) async {
    await tester.pumpWidget(
      host(const NotificationsState.error(AppFailure.networkError())),
    );
    await tester.pump();
    expect(find.text("Couldn't load your activity"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
