import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/pagination/paginated_list_cubit.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Fake 3-page source over usernames; page 2 overlaps page 1 (to prove de-dupe).
Future<Result<CursorPage<String>>> _fakeSource(PageRequest request) async {
  switch (request.cursor) {
    case null:
      return const Result.ok(
        CursorPage(items: ['u1', 'u2'], nextCursor: 'c1', hasMore: true),
      );
    case 'c1':
      return const Result.ok(
        CursorPage(items: ['u2', 'u3'], nextCursor: 'c2', hasMore: true),
      );
    default:
      return const Result.ok(
        CursorPage(items: ['u4'], nextCursor: null, hasMore: false),
      );
  }
}

PaginatedListCubit<String> _cubit([PageFetcher<String>? source]) =>
    PaginatedListCubit<String>(
      fetchPage: source ?? _fakeSource,
      idSelector: (s) => s,
    );

void main() {
  group('PaginatedListCubit (US3 / SC-004)', () {
    test('loadFirst → loaded first page', () async {
      final cubit = _cubit();
      await cubit.loadFirst();
      expect(cubit.state, isA<PaginatedLoaded<String>>());
      expect(cubit.state.items, ['u1', 'u2']);
      expect(cubit.state.hasMore, isTrue);
      await cubit.close();
    });

    test('loadMore appends + de-dupes across pages', () async {
      final cubit = _cubit();
      await cubit.loadFirst();
      await cubit.loadMore(); // page2 [u2,u3], u2 deduped
      expect(cubit.state.items, ['u1', 'u2', 'u3']);
      expect(cubit.state.hasMore, isTrue);
      await cubit.close();
    });

    test(
      'reaching the last page sets hasMore=false; further loadMore is a no-op',
      () async {
        final cubit = _cubit();
        await cubit.loadFirst();
        await cubit.loadMore(); // → c1
        await cubit.loadMore(); // → c2 (last, [u4])
        expect(cubit.state.items, ['u1', 'u2', 'u3', 'u4']);
        expect(cubit.state.hasMore, isFalse);
        final before = cubit.state.items;
        await cubit.loadMore(); // no-op
        expect(cubit.state.items, before);
        await cubit.close();
      },
    );

    test('refresh reloads from the first page (replaces items)', () async {
      final cubit = _cubit();
      await cubit.loadFirst();
      await cubit.loadMore();
      await cubit.refresh();
      expect(cubit.state.items, ['u1', 'u2']);
      expect(cubit.state, isA<PaginatedLoaded<String>>());
      await cubit.close();
    });

    test('first-page failure → error state', () async {
      final cubit = _cubit(
        (_) async => const Result.err(AppFailure.serverError()),
      );
      await cubit.loadFirst();
      expect(cubit.state, isA<PaginatedError<String>>());
      await cubit.close();
    });

    test(
      'load-more failure keeps already-loaded items (soft failure)',
      () async {
        var call = 0;
        final cubit = _cubit((request) async {
          call++;
          if (call == 1) {
            return const Result.ok(
              CursorPage(items: ['u1'], nextCursor: 'c1', hasMore: true),
            );
          }
          return const Result.err(AppFailure.networkError());
        });
        await cubit.loadFirst();
        await cubit.loadMore();
        expect(cubit.state, isA<PaginatedLoaded<String>>());
        expect(cubit.state.items, ['u1']); // retained
        await cubit.close();
      },
    );
  });
}
