import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/notification_bell.dart';
import '../chat/chat_list_screen.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: const [NotificationBell()],
      ),
      body: const ChatListScreen(),
    );
  }
}
