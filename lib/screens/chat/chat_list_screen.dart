import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/chat.dart';
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

class _ThreadTile extends StatelessWidget {
  final ChatThread thread;
  const _ThreadTile({required this.thread});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM, HH:mm');
    final last = thread.lastMessageAt;
    final others = thread.participantPhones.length > 1
        ? thread.participantPhones.sublist(1).join(', ')
        : thread.participantPhones.join(', ');
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
      title: Text(thread.jobTitle ?? 'Suhbat'),
      subtitle: Text(others, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        last != null ? fmt.format(last.toLocal()) : '',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () => context.push('/threads/${thread.id}',
          extra: thread.jobTitle ?? 'Suhbat'),
    );
  }
}

class _EmptyChats extends StatelessWidget {
  const _EmptyChats();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text(
              'Hozircha suhbatlar yo\u02bcq.\nTaklif yuborgandan so\u02bcng suhbatlar shu yerda paydo bo\u02bcladi.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
