import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/stories/data/create_story_repository_fake.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/presentation/compose/story_compose_page.dart';
import 'package:we36/features/stories/presentation/compose/story_pick_page.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../support/fake_story_image_composer.dart';

/// Golden coverage for the create-story flow (pick + 9:16 compose canvas) in
/// light + dark (T023). Deterministic fakes paint real (solid-colour) bytes
/// with no network — Constitution XII. Regenerate baselines with
/// `flutter test --update-goldens`.
void main() {
  late AppDatabase db;
  late StoryGalleryCubit gallery;
  late StoryComposeCubit compose;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gallery = StoryGalleryCubit(FakePhotoLibraryService(assetCount: 8));
    final repo = FakeCreateStoryRepository(
      FakeMediaUploadService()..stepDelay = Duration.zero,
      db,
      OwnStoryStore(),
    );
    compose = StoryComposeCubit(
      PublishStory(repo),
      FakeStoryImageComposer(),
      IdempotencyKeys(),
    );
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(() async {
    await gallery.close();
    await compose.close();
    await db.close();
    await getIt.reset();
  });

  Widget host(Widget child, ThemeMode mode) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: mode,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: gallery),
        BlocProvider.value(value: compose),
      ],
      child: child,
    ),
  );

  Future<void> pumpForGolden(
    WidgetTester tester,
    Widget child,
    ThemeMode mode,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      await tester.pumpWidget(host(child, mode));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 32));
        await Future<void>.delayed(const Duration(milliseconds: 16));
      }
    });
    await tester.pump();
  }

  Future<void> goldenBoth(
    WidgetTester tester,
    String name,
    Future<void> Function() prime,
    Widget child,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await prime();
      await pumpForGolden(tester, child, mode);
      final suffix = mode == ThemeMode.dark ? 'dark' : 'light';
      await expectLater(
        find.byWidget(child),
        matchesGoldenFile('goldens/${name}_$suffix.png'),
      );
    }
  }

  testWidgets('story pick page golden (one selected)', (tester) async {
    const child = StoryPickPage();
    await goldenBoth(
      tester,
      'story_pick',
      () async {
        await gallery.loadInitial();
        gallery.select('fake-asset-0');
      },
      child,
    );
  });

  testWidgets('story compose canvas golden', (tester) async {
    const child = StoryComposePage();
    await goldenBoth(
      tester,
      'story_compose',
      () async {
        await gallery.loadInitial();
        compose.startFromAsset('fake-asset-0');
      },
      child,
    );
  });

  testWidgets('story compose canvas with overlays golden', (tester) async {
    const child = StoryComposePage();
    await goldenBoth(
      tester,
      'story_compose_overlays',
      () async {
        await gallery.loadInitial();
        // startFromAsset resets the draft → deterministic across light/dark.
        compose
          ..startFromAsset('fake-asset-0')
          ..addText('hi there')
          ..addSticker('❤️');
      },
      child,
    );
  });
}
