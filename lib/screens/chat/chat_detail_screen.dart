import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/chat.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../providers/safety_provider.dart';
import '../../providers/worker_search_provider.dart';
import '../../services/api_client.dart';
import '../../utils/offer_input.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/snack.dart';

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
      _scrollToBottom();
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(
          context,
          AppLocalizations.of(context).chatSendFailed,
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _insertQuick(String text) {
    final current = _input.text.trim();
    _input.text = current.isEmpty ? text : '$current\n$text';
    _input.selection = TextSelection.collapsed(offset: _input.text.length);
    ref.read(threadMessagesProvider(widget.threadId).notifier).sendTyping();
  }

  Future<void> _openAgreementSheet(ChatThread thread) async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AgreementSheet(thread: thread),
      ),
    );
    if (created == true) {
      ref.invalidate(threadsProvider);
      await ref
          .read(threadMessagesProvider(widget.threadId).notifier)
          .refresh();
      _scrollToBottom();
    }
  }

  Future<void> _callContact(ChatContactSummary contact) async {
    final l10n = AppLocalizations.of(context);
    final rawUri = contact.callUri.isNotEmpty
        ? contact.callUri
        : 'tel:${contact.counterpart.phone}';
    try {
      final launched = await launchUrl(
        Uri.parse(rawUri),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        showSnack(context, l10n.chatCallFailed, error: true);
      }
    } catch (_) {
      if (mounted) showSnack(context, l10n.chatCallFailed, error: true);
    }
  }

  Future<void> _blockUser(ChatParticipant user) async {
    final l10n = AppLocalizations.of(context);
    final name = _participantName(l10n, user);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.safetyBlockTitle(name)),
        content: Text(l10n.safetyBlockConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.safetyBlockAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(safetyRepositoryProvider).blockUser(user.id);
      ref.invalidate(myBlocksProvider);
      ref.invalidate(threadsProvider);
      ref.invalidate(nearbyWorkersProvider);
      if (mounted) showSnack(context, l10n.safetyBlocked(name));
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, l10n.commonNetworkError, error: true);
    }
  }

  Future<void> _unblockUser(ChatParticipant user) async {
    final l10n = AppLocalizations.of(context);
    final name = _participantName(l10n, user);
    try {
      await ref.read(safetyRepositoryProvider).unblockUser(user.id);
      ref.invalidate(myBlocksProvider);
      ref.invalidate(threadsProvider);
      ref.invalidate(nearbyWorkersProvider);
      if (mounted) showSnack(context, l10n.safetyUnblocked(name));
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, l10n.commonNetworkError, error: true);
    }
  }

  Future<void> _reportUser(ChatParticipant user, ChatThread thread) async {
    final reported = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _ReportUserSheet(user: user, thread: thread),
      ),
    );
    if (reported == true && mounted) {
      showSnack(context, AppLocalizations.of(context).safetyReportSent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final messagesState = ref.watch(threadMessagesProvider(widget.threadId));
    final threadsState = ref.watch(threadsProvider);
    final auth = ref.watch(authControllerProvider);
    final myId = auth is AuthSignedIn ? auth.user.id : null;
    final thread = threadsState.valueOrNull
        ?.where((item) => item.id == widget.threadId)
        .firstOrNull;
    final other = _otherParticipant(thread, myId);
    final blocksState = ref.watch(myBlocksProvider);
    final isBlockedByMe = other != null &&
        (thread?.blockedByMe == true ||
            blocksState.valueOrNull
                    ?.any((block) => block.blockedId == other.id) ==
                true);
    final isBlockedMe = thread?.blockedMe == true;
    final title =
        _threadTitle(l10n, thread, myId) ?? widget.title ?? l10n.chatTitle;
    final messages = messagesState.valueOrNull ?? const <ChatMessage>[];
    final hasOpenAgreement = messages.any(
      (msg) => msg.offerSummary?.isOpen == true,
    );
    final canCreateAgreement = thread != null &&
        myId != null &&
        thread.jobSource == 'street_contact' &&
        thread.jobCreatorId == myId &&
        thread.jobStatus != 'assigned' &&
        !isBlockedByMe &&
        !isBlockedMe &&
        !hasOpenAgreement;
    final contactState = thread != null && _canFetchContact(thread.jobStatus)
        ? ref.watch(threadContactProvider(widget.threadId))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (canCreateAgreement)
            IconButton(
              tooltip: l10n.chatAgreementAction,
              onPressed: () => _openAgreementSheet(thread),
              icon: const Icon(Icons.assignment_turned_in_outlined),
            ),
          if (thread != null && other != null)
            PopupMenuButton<_ChatSafetyAction>(
              tooltip: l10n.safetyMenuTooltip,
              onSelected: (action) {
                switch (action) {
                  case _ChatSafetyAction.report:
                    _reportUser(other, thread);
                  case _ChatSafetyAction.block:
                    _blockUser(other);
                  case _ChatSafetyAction.unblock:
                    _unblockUser(other);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _ChatSafetyAction.report,
                  child: ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: Text(l10n.safetyReportAction),
                  ),
                ),
                PopupMenuItem(
                  value: isBlockedByMe
                      ? _ChatSafetyAction.unblock
                      : _ChatSafetyAction.block,
                  child: ListTile(
                    leading: Icon(
                      isBlockedByMe
                          ? Icons.lock_open_outlined
                          : Icons.block_outlined,
                    ),
                    title: Text(
                      isBlockedByMe
                          ? l10n.safetyUnblockAction
                          : l10n.safetyBlockAction,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          if (thread != null)
            _ThreadContextBand(
              thread: thread,
              myId: myId,
              contactState: contactState,
              onCreateAgreement:
                  canCreateAgreement ? () => _openAgreementSheet(thread) : null,
              onCall: _callContact,
            ),
          Expanded(
            child: AsyncStateView<List<ChatMessage>>(
              state: messagesState,
              isEmpty: (items) => items.isEmpty,
              emptyView: const _Hint(),
              onRetry: () => ref
                  .read(threadMessagesProvider(widget.threadId).notifier)
                  .refresh(),
              data: (msgs) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scroll.hasClients && msgs.length <= 2) {
                    _scroll.jumpTo(_scroll.position.maxScrollExtent);
                  }
                });
                return ListView.builder(
                  controller: _scroll,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: msgs.length,
                  itemBuilder: (_, index) {
                    final msg = msgs[index];
                    final previous = index == 0 ? null : msgs[index - 1];
                    final showDate = previous == null ||
                        !_sameDay(previous.createdAt, msg.createdAt);
                    final grouped = previous != null &&
                        previous.senderId == msg.senderId &&
                        _sameDay(previous.createdAt, msg.createdAt) &&
                        msg.createdAt.difference(previous.createdAt).inMinutes <
                            8;
                    return Column(
                      children: [
                        if (showDate) _DatePill(date: msg.createdAt),
                        if (msg.isOffer)
                          _AgreementCard(
                            msg: msg,
                            myId: myId,
                            grouped: grouped,
                            offerActionsEnabled: !isBlockedByMe && !isBlockedMe,
                          )
                        else
                          _Bubble(msg: msg, myId: myId, grouped: grouped),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: isBlockedByMe || isBlockedMe
                  ? _BlockedComposer(
                      message: _blockedComposerMessage(
                        l10n,
                        _participantName(l10n, other!),
                        blockedByMe: isBlockedByMe,
                        blockedMe: isBlockedMe,
                      ),
                      onUnblock:
                          isBlockedByMe ? () => _unblockUser(other) : null,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ActionChip(
                                avatar:
                                    const Icon(Icons.place_outlined, size: 18),
                                label: Text(l10n.chatQuickLocation),
                                onPressed: () => _insertQuick(
                                  l10n.chatQuickLocationMessage,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ActionChip(
                                avatar: const Icon(
                                  Icons.payments_outlined,
                                  size: 18,
                                ),
                                label: Text(l10n.chatQuickPrice),
                                onPressed: () =>
                                    _insertQuick(l10n.chatQuickPriceMessage),
                              ),
                              const SizedBox(width: 8),
                              ActionChip(
                                avatar:
                                    const Icon(Icons.auto_awesome, size: 18),
                                label: Text(l10n.chatQuickYordam),
                                onPressed: () =>
                                    _insertQuick(l10n.chatQuickYordamMessage),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _input,
                                minLines: 1,
                                maxLines: 5,
                                textInputAction: TextInputAction.newline,
                                onChanged: (_) => ref
                                    .read(
                                      threadMessagesProvider(widget.threadId)
                                          .notifier,
                                    )
                                    .sendTyping(),
                                decoration: InputDecoration(
                                  hintText: l10n.chatMessageHint,
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              tooltip: l10n.offerSubmit,
                              onPressed: _sending ? null : _send,
                              icon: _sending
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.send),
                            ),
                          ],
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

enum _ChatSafetyAction { report, block, unblock }

class _BlockedComposer extends StatelessWidget {
  final String message;
  final VoidCallback? onUnblock;

  const _BlockedComposer({required this.message, required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.block_outlined, color: theme.colorScheme.error),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (onUnblock != null)
              TextButton(
                onPressed: onUnblock,
                child: Text(l10n.safetyUnblockAction),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReportUserSheet extends ConsumerStatefulWidget {
  final ChatParticipant user;
  final ChatThread thread;

  const _ReportUserSheet({required this.user, required this.thread});

  @override
  ConsumerState<_ReportUserSheet> createState() => _ReportUserSheetState();
}

class _ReportUserSheetState extends ConsumerState<_ReportUserSheet> {
  final _details = TextEditingController();
  String _reason = 'abuse';
  bool _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(safetyRepositoryProvider).reportUser(
            userId: widget.user.id,
            reason: _reason,
            details: _details.text.trim(),
            threadId: widget.thread.id,
            jobId: widget.thread.jobId,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, l10n.commonNetworkError, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = _participantName(l10n, widget.user);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.safetyReportTitle(name),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.safetyReportSubtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              decoration:
                  InputDecoration(labelText: l10n.safetyReportReasonLabel),
              items: const [
                'abuse',
                'spam',
                'fraud',
                'off_platform',
                'safety',
                'other',
              ]
                  .map(
                    (reason) => DropdownMenuItem(
                      value: reason,
                      child: Text(_reportReasonLabel(l10n, reason)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _reason = value ?? 'other'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _details,
              minLines: 3,
              maxLines: 5,
              maxLength: 4000,
              decoration: InputDecoration(
                labelText: l10n.safetyReportDetailsLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.flag_outlined),
              label: Text(l10n.safetyReportSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadContextBand extends StatelessWidget {
  final ChatThread thread;
  final String? myId;
  final AsyncValue<ChatContactSummary>? contactState;
  final VoidCallback? onCreateAgreement;
  final ValueChanged<ChatContactSummary> onCall;

  const _ThreadContextBand({
    required this.thread,
    required this.myId,
    required this.contactState,
    required this.onCreateAgreement,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = _threadTitle(l10n, thread, myId) ?? l10n.chatTitle;
    final contact = contactState?.valueOrNull;
    final contactLoading = contactState?.isLoading == true;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Row(
          children: [
            CircleAvatar(radius: 18, child: Text(title.characters.first)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.jobTitle?.trim().isNotEmpty == true
                        ? thread.jobTitle!.trim()
                        : l10n.jobUntitled,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact?.available == true
                        ? l10n.chatContactUnlocked
                        : _canFetchContact(thread.jobStatus)
                            ? l10n.chatAgreementAlreadyAssigned
                            : l10n.chatAgreementPrivacy,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(_statusLabel(l10n, thread.jobStatus ?? '')),
              visualDensity: VisualDensity.compact,
            ),
            if (onCreateAgreement != null) ...[
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: l10n.chatAgreementAction,
                onPressed: onCreateAgreement,
                icon: const Icon(Icons.assignment_add),
              ),
            ],
            if (contactLoading) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ] else if (contact != null && contact.available) ...[
              const SizedBox(width: 4),
              IconButton.filledTonal(
                tooltip: l10n.chatCallAction,
                onPressed: () => onCall(contact),
                icon: const Icon(Icons.call_outlined),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AgreementCard extends ConsumerStatefulWidget {
  final ChatMessage msg;
  final String? myId;
  final bool grouped;
  final bool offerActionsEnabled;

  const _AgreementCard({
    required this.msg,
    required this.myId,
    required this.grouped,
    required this.offerActionsEnabled,
  });

  @override
  ConsumerState<_AgreementCard> createState() => _AgreementCardState();
}

class _AgreementCardState extends ConsumerState<_AgreementCard> {
  bool _busy = false;

  Future<void> _act(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      final offer = widget.msg.offerSummary!;
      ref.invalidate(threadsProvider);
      ref.invalidate(threadContactProvider(widget.msg.threadId));
      ref.invalidate(workerAssignmentsProvider('active'));
      ref.invalidate(workerAssignmentsProvider('history'));
      ref.invalidate(myJobsProvider);
      ref.invalidate(jobDetailProvider(offer.jobId));
      await ref
          .read(threadMessagesProvider(widget.msg.threadId).notifier)
          .refresh();
      if (mounted) showSnack(context, success);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(
          context,
          AppLocalizations.of(context).jobDetailActionFailed,
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _counter(ChatOfferSummary offer) async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _CounterOfferSheet(threadId: widget.msg.threadId, offer: offer),
      ),
    );
    if (created == true) {
      ref.invalidate(threadsProvider);
      ref.invalidate(threadContactProvider(widget.msg.threadId));
      ref.invalidate(jobDetailProvider(offer.jobId));
      await ref
          .read(threadMessagesProvider(widget.msg.threadId).notifier)
          .refresh();
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).chatCounterSent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.msg.offerSummary!;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final fmt = NumberFormat.decimalPattern();
    final amount = offer.amount == null
        ? l10n.pricingNegotiable
        : '${fmt.format(offer.amount)} ${offer.currency}${offer.pricingModel == 'hourly' ? l10n.offerPerHourSuffix : ''}';
    final canRespond = widget.offerActionsEnabled &&
        offer.isOpen &&
        widget.myId == offer.recipientId;
    final alignment = widget.myId == widget.msg.senderId
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final borderColor = offer.isAccepted
        ? Colors.green
        : offer.isDeclined
            ? theme.colorScheme.outline
            : theme.colorScheme.primary;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Card(
          margin: EdgeInsets.only(top: widget.grouped ? 2 : 8, bottom: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor.withValues(alpha: 0.55)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      color: borderColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.chatAgreementCardTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Chip(
                      label: Text(_statusLabel(l10n, offer.status)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(amount, style: theme.textTheme.titleSmall),
                if (offer.durationEstimateHours != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.offerDurationEstimate(
                      offer.durationEstimateHours!.toString(),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (offer.proposedStart != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().add_Hm().format(
                          offer.proposedStart!.toLocal(),
                        ),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (offer.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(offer.note.trim()),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('HH:mm').format(widget.msg.createdAt.toLocal()),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                if (canRespond) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _busy ? null : () => _counter(offer),
                        icon: const Icon(Icons.sync_alt),
                        label: Text(l10n.chatCounterAction),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => _act(
                                  () => ref
                                      .read(offersRepositoryProvider)
                                      .decline(offer.id),
                                  l10n.chatAgreementDeclined,
                                ),
                        child: Text(l10n.offerDecline),
                      ),
                      FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _act(
                                  () => ref
                                      .read(offersRepositoryProvider)
                                      .accept(offer.id),
                                  l10n.chatAgreementAccepted,
                                ),
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(l10n.offerAccept),
                      ),
                    ],
                  ),
                ],
                if (offer.isAccepted) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/jobs/${offer.jobId}'),
                    icon: const Icon(Icons.work_outline),
                    label: Text(l10n.jobDetailTitle),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterOfferSheet extends ConsumerStatefulWidget {
  final String threadId;
  final ChatOfferSummary offer;

  const _CounterOfferSheet({required this.threadId, required this.offer});

  @override
  ConsumerState<_CounterOfferSheet> createState() => _CounterOfferSheetState();
}

class _CounterOfferSheetState extends ConsumerState<_CounterOfferSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _hours;
  late final TextEditingController _note;
  late String _pricingModel;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final offer = widget.offer;
    _pricingModel = offer.pricingModel == 'hourly' ? 'hourly' : 'fixed';
    _amount = TextEditingController(text: offer.amount?.toString() ?? '');
    _hours = TextEditingController(
      text: offer.durationEstimateHours?.toString() ?? '',
    );
    _note = TextEditingController(text: offer.note);
  }

  @override
  void dispose() {
    _amount.dispose();
    _hours.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!(_form.currentState?.validate() ?? false)) return;
    final amount = parsePositiveAmount(_amount.text)!;
    setState(() => _busy = true);
    try {
      await ref.read(chatRepositoryProvider).counterOffer(
            threadId: widget.threadId,
            offerId: widget.offer.id,
            pricingModel: _pricingModel,
            amount: amount,
            durationEstimateHours: parseOptionalPositiveHours(_hours.text),
            note: _note.text.trim(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, l10n.chatCounterSendFailed, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.chatCounterCreateTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.chatCounterSubtitle,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'fixed',
                      label: Text(l10n.pricingFixed),
                    ),
                    ButtonSegment(
                      value: 'hourly',
                      label: Text(l10n.pricingHourly),
                    ),
                  ],
                  selected: {_pricingModel},
                  onSelectionChanged: _busy
                      ? null
                      : (value) => setState(() => _pricingModel = value.first),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _pricingModel == 'hourly'
                        ? l10n.offerHourlyRateLabel
                        : l10n.offerTotalAmountLabel,
                  ),
                  validator: (value) => parsePositiveAmount(value ?? '') == null
                      ? l10n.offerAmountRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _hours,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: l10n.offerEstimatedHoursLabel),
                  validator: (value) => hasInvalidOptionalHours(value ?? '')
                      ? l10n.offerHoursInvalid
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _note,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: l10n.offerNoteLabel,
                    hintText: l10n.chatCounterNoteHint,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _busy ? null : _submit,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync_alt),
                  label: Text(l10n.chatCounterAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementSheet extends ConsumerStatefulWidget {
  final ChatThread thread;
  const _AgreementSheet({required this.thread});

  @override
  ConsumerState<_AgreementSheet> createState() => _AgreementSheetState();
}

class _AgreementSheetState extends ConsumerState<_AgreementSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _hours = TextEditingController();
  final _note = TextEditingController();
  String _pricingModel = 'fixed';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.thread.jobTitle ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _amount.dispose();
    _hours.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!(_form.currentState?.validate() ?? false)) return;
    final amount = parsePositiveAmount(_amount.text)!;
    setState(() => _busy = true);
    try {
      await ref.read(chatRepositoryProvider).createAgreement(
            threadId: widget.thread.id,
            title: _title.text.trim(),
            description: _description.text.trim(),
            pricingModel: _pricingModel,
            amount: amount,
            durationEstimateHours: parseOptionalPositiveHours(_hours.text),
            note: _note.text.trim(),
          );
      if (!mounted) return;
      ref.invalidate(threadsProvider);
      Navigator.of(context).pop(true);
      showSnack(context, l10n.chatAgreementSent);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, l10n.chatAgreementSendFailed, error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.chatAgreementCreateTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.chatAgreementSubtitle,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(labelText: l10n.draftTitleLabel),
                  validator: (value) => value?.trim().isEmpty == true
                      ? l10n.draftTitleRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.chatAgreementDescriptionLabel,
                    hintText: l10n.chatAgreementDescriptionHint,
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? l10n.chatAgreementDescriptionRequired
                      : null,
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'fixed',
                      label: Text(l10n.pricingFixed),
                    ),
                    ButtonSegment(
                      value: 'hourly',
                      label: Text(l10n.pricingHourly),
                    ),
                  ],
                  selected: {_pricingModel},
                  onSelectionChanged: _busy
                      ? null
                      : (value) => setState(() => _pricingModel = value.first),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _pricingModel == 'hourly'
                        ? l10n.offerHourlyRateLabel
                        : l10n.offerTotalAmountLabel,
                  ),
                  validator: (value) => parsePositiveAmount(value ?? '') == null
                      ? l10n.offerAmountRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _hours,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: l10n.offerEstimatedHoursLabel),
                  validator: (value) => hasInvalidOptionalHours(value ?? '')
                      ? l10n.offerHoursInvalid
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _note,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: l10n.offerNoteLabel,
                    hintText: l10n.chatAgreementNoteHint,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _busy ? null : _submit,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.assignment_turned_in_outlined),
                  label: Text(l10n.chatAgreementAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  final String? myId;
  final bool grouped;
  const _Bubble({required this.msg, required this.myId, required this.grouped});

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
          margin: EdgeInsets.only(top: grouped ? 2 : 6, bottom: 2),
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
                      Text(
                        l10n.chatAiName,
                        style: theme.textTheme.labelSmall?.copyWith(color: fg),
                      ),
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

class _DatePill extends StatelessWidget {
  final DateTime date;
  const _DatePill({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            DateFormat.yMMMd().format(date.toLocal()),
            style: theme.textTheme.labelSmall,
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

String? _threadTitle(AppLocalizations l10n, ChatThread? thread, String? myId) {
  if (thread == null) return null;
  final other = _otherParticipant(thread, myId);
  final name = other?.displayName;
  return name?.isNotEmpty == true ? name : thread.jobTitle ?? l10n.chatTitle;
}

ChatParticipant? _otherParticipant(ChatThread? thread, String? myId) {
  if (thread == null) return null;
  return thread.participants
      .where((participant) => participant.id != myId)
      .firstOrNull;
}

String _participantName(AppLocalizations l10n, ChatParticipant user) {
  return user.displayName.isNotEmpty ? user.displayName : l10n.chatTitle;
}

String _reportReasonLabel(AppLocalizations l10n, String reason) {
  return switch (reason) {
    'abuse' => l10n.safetyReportReasonAbuse,
    'spam' => l10n.safetyReportReasonSpam,
    'fraud' => l10n.safetyReportReasonFraud,
    'off_platform' => l10n.safetyReportReasonOffPlatform,
    'safety' => l10n.safetyReportReasonSafety,
    _ => l10n.safetyReportReasonOther,
  };
}

String _blockedComposerMessage(
  AppLocalizations l10n,
  String name, {
  required bool blockedByMe,
  required bool blockedMe,
}) {
  if (blockedByMe && blockedMe) return l10n.safetyMutualBlockedComposer(name);
  if (blockedMe) return l10n.safetyBlockedByThemComposer(name);
  return l10n.safetyBlockedComposer(name);
}

String _statusLabel(AppLocalizations l10n, String status) {
  return switch (status) {
    'draft' => l10n.statusDraft,
    'posted' => l10n.statusPosted,
    'assigned' => l10n.statusAssigned,
    'in_progress' => l10n.statusInProgress,
    'completed' => l10n.statusCompleted,
    'cancelled' => l10n.statusCancelled,
    'sent' => l10n.statusPending,
    'accepted' => l10n.statusAccepted,
    'declined' => l10n.statusDeclined,
    'withdrawn' => l10n.statusWithdrawn,
    'countered' => l10n.statusCountered,
    _ => status.isEmpty ? l10n.statusOpen : status,
  };
}

bool _canFetchContact(String? status) {
  return switch (status) {
    'assigned' || 'in_progress' || 'completed' || 'disputed' => true,
    _ => false,
  };
}

bool _sameDay(DateTime a, DateTime b) {
  final left = a.toLocal();
  final right = b.toLocal();
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
