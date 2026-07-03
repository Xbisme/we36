import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/domain/usecases/explore_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/explore_page.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #009 US2 (T035): the Explore grid renders mixed tiles (reels marked) at phone
/// and tablet widths.
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;
  late ExploreCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
    cubit = ExploreCubit(
      WatchExplore(repo),
      LoadExploreFirst(repo),
      LoadExploreNext(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  Widget host() => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider.value(value: cubit, child: const ExplorePage()),
  );

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await cubit.loadInitial();
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('phone grid renders tiles with a reel marker', (tester) async {
    await pumpAt(tester, const Size(390, 1400));
    expect(find.byType(DiscoveryGridTile), findsWidgets);
    // Reel tiles carry an a11y label distinguishing them from photos.
    expect(find.bySemanticsLabel(RegExp('Reel')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('Photo')), findsWidgets);
  });

  testWidgets('tablet width still renders the grid (responsive)', (
    tester,
  ) async {
    await pumpAt(tester, const Size(900, 1400));
    expect(find.byType(DiscoveryGridTile), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
