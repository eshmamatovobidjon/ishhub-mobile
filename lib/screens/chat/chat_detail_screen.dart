import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../services/api_client.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/snack.dart';

/// Live thread view backed by REST + WebSocket. Tag a message with `@yordam`
/// to invoke the AI mediator.
class ChatDetailScreen extends ConsumerStatefulWidget {
  final String threadId;
  final String? title;
  const ChatDetailScreen({super.key, required this.threadId, this.title});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(threadMessagesProvider(widget.threadId).notifier)
          .sendText(body);
      _input.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent + 80,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).chatSendFailed,
            error: true);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(threadMessagesProvider(widget.threadId));
    final me = ref.watch(authControllerProvider);
    final myId = me is AuthSignedIn ? me.user.id : null;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? l10n.chatTitle)),
      body: Column(
        children: [
          Expanded(
            child: AsyncStateView<List<ChatMessage>>(
              state: state,
              isEmpty: (l) => l.isEmpty,
              emptyView: const _Hint(),
              onRetry: () => ref
                  .read(threadMessagesProvider(widget.threadId).notifier)
                  .refresh(),
              data: (msgs) => ListView.builder(
                controller: _scroll,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: msgs.length,
                itemBuilder: (_, i) => _Bubble(msg: msgs[i], myId: myId),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => ref
                          .read(
                              threadMessagesProvider(widget.threadId).notifier)
                          .sendTyping(),
                      decoration: InputDecoration(
                        hintText: l10n.chatMessageHint,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  final String? myId;
  const _Bubble({required this.msg, required this.myId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isMine = myId != null && msg.senderId == myId;
    final isAi = msg.isFromAi;
    final align = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final bg = isAi
        ? theme.colorScheme.tertiaryContainer
        : isMine
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest;
    final fg = isAi
        ? theme.colorScheme.onTertiaryContainer
        : isMine
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface;
    final body = msg.kind == 'voice'
        ? (msg.transcript?.isNotEmpty == true
            ? msg.transcript!
            : l10n.chatVoiceMessage)
        : msg.body;
    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAi)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: fg),
                      const SizedBox(width: 4),
                      Text(l10n.chatAiName,
                          style:
                              theme.textTheme.labelSmall?.copyWith(color: fg)),
                    ],
                  ),
                ),
              Text(body, style: TextStyle(color: fg)),
              const SizedBox(height: 2),
              Text(
                DateFormat('HH:mm').format(msg.createdAt.toLocal()),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: fg.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.chatStartHint,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
