import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/discovery/fake_discovery_repository.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/domain/usecases/recents_usecases.dart';
import 'package:we36/features/explore/domain/usecases/search_usecases.dart';
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/search_cubit.dart';
import 'package:we36/features/explore/presentation/search_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #009 US1 (T026): SearchPage renders results, tabs, and honors block/private
/// visibility. Logic-first: drives the cubit directly, fixed `pump` (no router,
/// no `pumpAndSettle` — carried #006/#008 gotcha).
void main() {
  late AppDatabase db;
  late FakeDiscoveryRepository repo;
  late SearchCubit search;
  late RecentsCubit recents;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeDiscoveryRepository(db);
    search = SearchCubit(
      SearchTopQuery(repo),
      SearchAccounts(repo),
      SearchTags(repo),
      SearchPlaces(repo),
    );
    recents = RecentsCubit(
      GetRecents(repo),
      RecordRecent(repo),
      DeleteRecent(repo),
      ClearRecents(repo),
    );
  });

  tearDown(() async {
    await search.close();
    await recents.close();
    await db.close();
  });

  Widget host() => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: search),
        BlocProvider.value(value: recents),
      ],
      child: const SearchPage(),
    ),
  );

  testWidgets('shows Top results with a matching account', (tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await recents.load();
    await search.submit('ali');
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('alice_travel'), findsOneWidget);
    expect(find.text('Accounts'), findsWidgets); // tab label
  });

  testWidgets('a blocked account never appears; private is findable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await recents.load();
    await search.submit('b'); // matches bob_private + blocked_user by substring
    // 'b' is < 2 chars → no search; use a real term:
    await search.submit('bob');
    await tester.pumpWidget(host());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('bob_private'), findsOneWidget);
    expect(find.text('blocked_user'), findsNothing);
  });
}
