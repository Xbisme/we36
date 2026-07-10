import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/moderation/fake_block_repository.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/data/moderation/report_repository.dart';

void main() {
  group('FakeBlockRepository (#014 US3)', () {
    test('block adds and unblock removes; list reflects it', () async {
      final repo = FakeBlockRepository();
      final before = (await repo.listBlocked()).valueOrNull!;
      expect(before.items, hasLength(1)); // seeded spam account

      await repo.block('u_new');
      final after = (await repo.listBlocked()).valueOrNull!;
      expect(after.items.any((u) => u.id == 'u_new'), isTrue);

      await repo.unblock('u_new');
      final finalPage = (await repo.listBlocked()).valueOrNull!;
      expect(finalPage.items.any((u) => u.id == 'u_new'), isFalse);
    });

    test('block returns blocking=true (mutual sever)', () async {
      final rel = (await FakeBlockRepository().block('x')).valueOrNull!;
      expect(rel.blocking, isTrue);
      expect(rel.following, isFalse);
      expect(rel.followsYou, isFalse);
    });

    test('block is idempotent (retry keeps one entry)', () async {
      final repo = FakeBlockRepository();
      await repo.block('dup');
      await repo.block('dup');
      final page = (await repo.listBlocked()).valueOrNull!;
      expect(page.items.where((u) => u.id == 'dup'), hasLength(1));
    });
  });

  group('FakeReportRepository (#014 US3)', () {
    test('report acks for any target/reason', () async {
      final repo = FakeReportRepository();
      final result = await repo.report(
        targetType: ReportTargetType.user,
        targetId: 'u1',
        reason: ReportReason.spam,
      );
      expect(result.isOk, isTrue);
    });

    test('reason enum matches the backend set (9 values)', () {
      expect(ReportReason.values, hasLength(9));
      expect(ReportReason.values, contains(ReportReason.intellectualProperty));
    });
  });
}
