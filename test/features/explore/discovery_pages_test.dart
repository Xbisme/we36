import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/domain/usecases/discovery_page_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_cubit.dart';
import 'package:we36/features/explore/presentation/discovery_grid_page.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #009 US4 (T046): hashtag/place pages render a header + grid; the hashtag
/// Follow control is surface-only (toasts, creates no relationship).
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;
  late DiscoveryGridCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
    cubit = DiscoveryGridCubit(LoadHashtagPage(repo), LoadPlacePage(repo));
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
    await getIt.reset();
  });

  Widget host() => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider.value(value: cubit, child: const DiscoveryGridPage()),
  );

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('hashtag page shows header, grid, and surface-only Follow', (
    tester,
  ) async {
    await cubit.initHashtag('travel');
    await pump(tester);

    expect(find.text('#travel'), findsWidgets);
    expect(find.byType(DiscoveryGridTile), findsWidgets);

    final follow = find.widgetWithText(OutlinedButton, 'Follow');
    expect(follow, findsOneWidget);
    await tester.tap(follow);
    await tester.pump(const Duration(milliseconds: 50));
    // Surface-only: the acknowledgement toast appears (no relationship created).
    expect(find.text('Following topics is coming soon.'), findsOneWidget);
    // Drain the toast's auto-dismiss timer so no timer is pending at teardown.
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('place page shows the place header + grid (no Follow)', (
    tester,
  ) async {
    await cubit.initPlace('place-da-nang');
    await pump(tester);

    expect(find.text('Da Nang'), findsWidgets);
    expect(find.byType(DiscoveryGridTile), findsWidgets);
    expect(find.widgetWithText(OutlinedButton, 'Follow'), findsNothing);
  });
}
