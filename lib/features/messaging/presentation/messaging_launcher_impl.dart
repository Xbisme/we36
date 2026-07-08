import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/messaging/message.dart' show PostRef;
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/presentation/slots/messaging_launcher.dart';

/// The messaging entry-seam implementation (#012, `@LazySingleton(as:
/// MessagingLauncher)`), consumed by profile / post / reels via `getIt`.
@LazySingleton(as: MessagingLauncher)
class MessagingLauncherImpl implements MessagingLauncher {
  MessagingLauncherImpl(this._repo);

  final MessagingRepository _repo;

  @override
  Future<void> openConversationWith(
    BuildContext context,
    String userId,
  ) async {
    final res = await _repo.openOrStartConversation(userId);
    final convo = res.valueOrNull;
    if (convo == null || !context.mounted) return;
    unawaited(
      context.push(AppRoutes.messageThreadPath(convo.id), extra: convo),
    );
  }

  @override
  void shareToDm(BuildContext context, PostRef ref) {
    // Open the compose picker carrying the shared post; it sends on select.
    unawaited(context.push(AppRoutes.newMessage, extra: ref));
  }
}
