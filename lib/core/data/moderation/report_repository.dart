import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/moderation/report.dart';
import 'package:we36/core/domain/result.dart';

/// Reporting (#014, US3, surface-only). Submits a report; the backend returns a
/// 202 acknowledgement and never reveals a moderation outcome. A real impl
/// (`env:['real']`) POSTs `/reports`; the fake (`env:['fake']`) acks.
// ignore: one_member_abstracts — an interface (not a typedef) so DI binds real/fake.
abstract interface class ReportRepository {
  Future<Result<void>> report({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
  });
}

@LazySingleton(as: ReportRepository, env: ['real'])
class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Result<void>> report({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
  }) => _api.post<void>(
    ApiEndpoints.reports,
    idempotent: true,
    body: {
      'targetType': targetType.name,
      'targetId': targetId,
      'reason': reason.name,
    },
    decode: (_) {},
  );
}

@LazySingleton(as: ReportRepository, env: ['fake'])
class FakeReportRepository implements ReportRepository {
  @override
  Future<Result<void>> report({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
  }) async => const Result<void>.ok(null);
}
