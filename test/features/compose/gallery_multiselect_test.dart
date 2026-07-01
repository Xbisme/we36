import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';

void main() {
  late GalleryCubit cubit;

  setUp(() => cubit = GalleryCubit(FakePhotoLibraryService(assetCount: 20)));
  tearDown(() => cubit.close());

  test('multi-select preserves selection order', () async {
    await cubit.loadInitial();
    cubit
      ..toggleSelect('fake-asset-3')
      ..toggleSelect('fake-asset-1')
      ..toggleSelect('fake-asset-7');
    expect(cubit.state.selectedIds, [
      'fake-asset-3',
      'fake-asset-1',
      'fake-asset-7',
    ]);
  });

  test(
    'deselecting removes from the ordered set, later items shift down',
    () async {
      await cubit.loadInitial();
      cubit
        ..toggleSelect('fake-asset-0')
        ..toggleSelect('fake-asset-1')
        ..toggleSelect('fake-asset-2')
        ..toggleSelect('fake-asset-1'); // remove the middle one
      expect(cubit.state.selectedIds, ['fake-asset-0', 'fake-asset-2']);
    },
  );

  test('cap of 10 blocks the 11th selection and returns false', () async {
    await cubit.loadInitial();
    for (var i = 0; i < kCarouselMaxItems; i++) {
      expect(cubit.toggleSelect('fake-asset-$i'), isTrue);
    }
    expect(cubit.state.selectedIds, hasLength(kCarouselMaxItems));
    // The 11th is refused (FR-006) and selection is unchanged.
    expect(cubit.toggleSelect('fake-asset-15'), isFalse);
    expect(cubit.state.selectedIds, hasLength(kCarouselMaxItems));
  });
}
