import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/notifications_provider.dart';

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsControllerProvider);
    final l10n = AppLocalizations.of(context);
    final count = state.unreadCount;
    final label = count > 9 ? '9+' : '$count';
    return IconButton(
      tooltip: l10n.notificationsTooltip,
      onPressed: () => context.push('/notifications'),
      icon: count == 0
          ? const Icon(Icons.notifications_outlined)
          : Badge(
              label: Text(label),
              child: const Icon(Icons.notifications_outlined),
            ),
    );
  }
}
