import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/caption_page.dart';
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

class _SyncImageProcessing extends ImageProcessingService {
  const _SyncImageProcessing();
  @override
  Future<Result<Uint8List>> bake({
    required Uint8List source,
    required MediaEditState edit,
    int targetWidth = ImageProcessingService.defaultTargetWidth,
    int quality = ImageProcessingService.defaultQuality,
  }) async => Result.ok(source);
}

/// Compose reflows by width using the shared #001 adaptive shell — the SAME page
/// widgets render at phone (`<700`) and tablet (`≥700`) widths (no forked
/// screens, FR-022).
void main() {
  late AppDatabase db;
  late GalleryCubit gallery;
  late ComposeCubit compose;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gallery = GalleryCubit(FakePhotoLibraryService());
    compose = ComposeCubit(
      PublishPost(
        FakePhotoLibraryService(),
        const _SyncImageProcessing(),
        FakeMediaUploadService()..stepDelay = Duration.zero,
        FakeCreatePostRepository(db),
      ),
      ComposeDraftStore(db),
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

  Widget host(Widget child) => MaterialApp(
    theme: AppTheme.light,
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

  Future<void> pumpAt(WidgetTester tester, Widget child, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host(child));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  const phone = Size(390, 844);
  const tablet = Size(1024, 1366);

  testWidgets('pick page renders at phone + tablet widths (one widget class)', (
    tester,
  ) async {
    await gallery.loadInitial();
    await pumpAt(tester, const PickPage(), phone);
    expect(find.byType(PickPage), findsOneWidget);
    expect(tester.takeException(), isNull);

    await pumpAt(tester, const PickPage(), tablet);
    expect(find.byType(PickPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit page reflows without a forked tablet screen', (
    tester,
  ) async {
    await compose.startFromAssets(['fake-asset-0']);
    await pumpAt(tester, const EditPage(), phone);
    expect(find.byType(EditPage), findsOneWidget);

    await pumpAt(tester, const EditPage(), tablet);
    expect(find.byType(EditPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('caption page reflows without a forked tablet screen', (
    tester,
  ) async {
    await compose.startFromAssets(['fake-asset-0']);
    await pumpAt(tester, const CaptionPage(), phone);
    expect(find.byType(CaptionPage), findsOneWidget);

    await pumpAt(tester, const CaptionPage(), tablet);
    expect(find.byType(CaptionPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
