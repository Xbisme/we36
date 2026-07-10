import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/notifications/notifications_dto.dart';
import 'package:we36/core/data/notifications/notifications_repository.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/notifications/notifications_badge.dart';
import 'package:we36/core/utils/app_logger.dart';

/// The sole `notification.new` subscriber (#013, Constitution VIII) — the second
/// live consumer of the #002 realtime socket (after #012 DM). Cubits/widgets
/// never touch [RealtimeClient]. It folds each inbound entry into the one
/// canonical cache via [NotificationsRepository.foldLiveEntry] (dedupe by id →
/// exactly once, SC-004 / FR-013) and pushes the fresh unread count to the badge
/// — silently, no banner/toast (clarified Q4). A malformed payload is skipped
/// with a redacted warn (Constitution IX) — one bad event never crashes the feed.
@lazySingleton
class NotificationsRealtimeService {
  NotificationsRealtimeService(
    this._client,
    this._repo,
    this._badge,
    this._logger,
  ) {
    _sub = _client.events.listen(_onEvent);
  }

  final RealtimeClient _client;
  final NotificationsRepository _repo;
  final NotificationsBadge _badge;
  final AppLogger _logger;

  late final StreamSubscription<InboundEvent> _sub;

  Future<void> _onEvent(InboundEvent event) async {
    if (event is! NotificationNew) return;
    try {
      final entry = notificationEntryFromDto(event.entry);
      if (entry.id.isEmpty) {
        _logger.warn('Dropped a notification.new with no id');
        return;
      }
      await _repo.foldLiveEntry(entry);
      _badge.push(event.unreadCount);
    } on Object catch (e) {
      // One bad payload must not crash the pipeline (redacted — no content).
      _logger.warn('Dropped a malformed notification event', data: {'e': '$e'});
    }
  }

  /// Tear down (retiring the singleton / tests).
  Future<void> dispose() async => _sub.cancel();
}
