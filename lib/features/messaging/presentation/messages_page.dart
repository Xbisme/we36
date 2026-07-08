import 'package:flutter/material.dart';
import 'package:we36/features/messaging/presentation/messaging_shell.dart';

/// The Messages tab body (#012) — the adaptive messaging surface: phone shows the
/// conversation list (pushing the chat), tablet/iPad shows the two-pane
/// master/detail (US5). See [MessagingShell].
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) => const MessagingShell();
}
