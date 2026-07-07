import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/explore_state.dart';
import 'package:we36/features/explore/presentation/explore_page.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/explore_test_doubles.dart';

/// #009 US2 (T035): the Explore grid renders mixed tiles (reels marked) at phone
/// and tablet widths. Driven by a seeded `StubExploreCubit` so the grid renders
/// synchronously — real drift I/O deadlocks inside `testWidgets`' faked async.
void main() {
  Widget host(ExploreCubit cubit) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<ExploreCubit>.value(
      value: cubit,
      child: const ExplorePage(),
    ),
  );

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    final cubit = StubExploreCubit(
      ExploreState.loaded(stubExploreItems(), hasMore: false),
    );
    addTearDown(cubit.close);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host(cubit));
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
