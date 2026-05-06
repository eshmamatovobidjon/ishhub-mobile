import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/async_state_view.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(threadsProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(threadsProvider.future),
      child: AsyncStateView<List<ChatThread>>(
        state: state,
        isEmpty: (list) => list.isEmpty,
        emptyView: const _EmptyChats(),
        onRetry: () => ref.refresh(threadsProvider.future),
        data: (threads) => ListView.separated(
          itemCount: threads.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _ThreadTile(thread: threads[i]),
        ),
      ),
    );
  }
}

class _ThreadTile extends ConsumerWidget {
  final ChatThread thread;
  const _ThreadTile({required this.thread});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('dd MMM, HH:mm');
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final myId = auth is AuthSignedIn ? auth.user.id : null;
    final last = thread.lastMessageAt;
    final names = thread.participants
        .where((p) => p.id != myId)
        .map((p) => p.displayName)
        .where((name) => name.isNotEmpty)
        .toList();
    final others = names.isNotEmpty ? names.join(', ') : l10n.chatTitle;
    final status = _statusLabel(l10n, thread.jobStatus ?? '');
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
      title: Text(thread.jobTitle ?? l10n.chatTitle),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(others, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Text(status, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      trailing: _ThreadTrailing(
        timeLabel: last != null ? fmt.format(last.toLocal()) : '',
        unreadCount: thread.unreadCount,
      ),
      onTap: () => context.push(
        '/threads/${thread.id}',
        extra: thread.jobTitle ?? l10n.chatTitle,
      ),
    );
  }
}

class _ThreadTrailing extends StatelessWidget {
  final String timeLabel;
  final int unreadCount;

  const _ThreadTrailing({required this.timeLabel, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = unreadCount > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeLabel,
          style: theme.textTheme.bodySmall?.copyWith(
            color: hasUnread ? theme.colorScheme.primary : null,
            fontWeight: hasUnread ? FontWeight.w600 : null,
          ),
        ),
        if (hasUnread) ...[
          const SizedBox(height: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String _statusLabel(AppLocalizations l10n, String status) {
  return switch (status) {
    'draft' => l10n.statusDraft,
    'posted' => l10n.statusPosted,
    'assigned' => l10n.statusAssigned,
    'in_progress' => l10n.statusInProgress,
    'completed' => l10n.statusCompleted,
    'cancelled' => l10n.statusCancelled,
    _ => status.isEmpty ? l10n.statusOpen : status,
  };
}

class _EmptyChats extends StatelessWidget {
  const _EmptyChats();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.chatEmpty,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
