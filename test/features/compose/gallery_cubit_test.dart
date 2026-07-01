import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_state.dart';

void main() {
  group('GalleryCubit (fake library)', () {
    test('loadInitial: loading → loaded with assets', () async {
      final cubit = GalleryCubit(FakePhotoLibraryService(assetCount: 10));
      final states = <GalleryState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.loadInitial();
      await sub.cancel();

      expect(states.first, isA<GalleryLoading>());
      expect(cubit.state, isA<GalleryLoaded>());
      expect(cubit.state.assets, hasLength(10));
      await cubit.close();
    });

    test('denied permission → error', () async {
      final cubit = GalleryCubit(
        FakePhotoLibraryService(permission: PhotoPermission.denied),
      );
      await cubit.loadInitial();
      expect(cubit.state, isA<GalleryError>());
      await cubit.close();
    });

    test('toggleSelect adds then removes, preserving order', () async {
      final cubit = GalleryCubit(FakePhotoLibraryService(assetCount: 5));
      await cubit.loadInitial();

      expect(cubit.toggleSelect('fake-asset-0'), isTrue);
      expect(cubit.toggleSelect('fake-asset-2'), isTrue);
      expect(cubit.state.selectedIds, ['fake-asset-0', 'fake-asset-2']);

      cubit.toggleSelect('fake-asset-0');
      expect(cubit.state.selectedIds, ['fake-asset-2']);
      await cubit.close();
    });

    test('loadMore appends the next page', () async {
      final cubit = GalleryCubit(FakePhotoLibraryService(assetCount: 130));
      await cubit.loadInitial();
      expect(cubit.state.assets, hasLength(60));

      await cubit.loadMore();
      expect(cubit.state.assets, hasLength(120));
      expect(cubit.state.hasMore, isTrue);
      await cubit.close();
    });
  });
}
