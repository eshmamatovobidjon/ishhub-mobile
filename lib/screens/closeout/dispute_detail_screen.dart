import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/dispute.dart';
import '../../providers/closeout_provider.dart';
import '../../widgets/async_state_view.dart';

class DisputeDetailScreen extends ConsumerWidget {
  final String disputeId;
  const DisputeDetailScreen({super.key, required this.disputeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(disputeDetailProvider(disputeId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.disputeDetailTitle)),
      body: AsyncStateView<Dispute>(
        state: state,
        onRetry: () => ref.refresh(disputeDetailProvider(disputeId).future),
        data: (dispute) => _DisputeDetail(dispute: dispute),
      ),
    );
  }
}

class _DisputeDetail extends StatelessWidget {
  final Dispute dispute;
  const _DisputeDetail({required this.dispute});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final fmt = DateFormat('dd MMM yyyy, HH:mm');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(_statusLabel(l10n, dispute.status))),
            Chip(label: Text(_outcomeLabel(l10n, dispute.outcome))),
          ],
        ),
        const SizedBox(height: 12),
        Text(_reasonLabel(l10n, dispute.reason),
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(dispute.description),
        const SizedBox(height: 8),
        Text(
          l10n.disputeOpenedAt(fmt.format(dispute.createdAt.toLocal())),
          style: theme.textTheme.bodySmall,
        ),
        if (dispute.evidenceUrls.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.disputeEvidenceLabel, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dispute.evidenceUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dispute.evidenceUrls[i],
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 112,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(l10n.disputeAiBriefTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (!dispute.hasAiBrief)
          Text(l10n.disputeAiBriefPending)
        else
          _AiBriefView(brief: dispute.aiBrief),
        if (dispute.resolutionNote.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.disputeResolutionTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(dispute.resolutionNote),
        ],
      ],
    );
  }
}

class _AiBriefView extends StatelessWidget {
  final Map<String, dynamic> brief;
  const _AiBriefView({required this.brief});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in brief.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title(entry.key),
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(_body(entry.value)),
              ],
            ),
          ),
      ],
    );
  }

  String _title(String key) => key.replaceAll('_', ' ');

  String _body(Object? value) {
    if (value is List) return value.map(_body).join('\n');
    if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${_body(e.value)}').join('\n');
    }
    return value?.toString() ?? '';
  }
}

String _statusLabel(AppLocalizations l10n, String status) => switch (status) {
      DisputeStatus.aiTriaged => l10n.disputeStatusAiTriaged,
      DisputeStatus.underReview => l10n.disputeStatusUnderReview,
      DisputeStatus.resolved => l10n.disputeStatusResolved,
      DisputeStatus.cancelled => l10n.disputeStatusCancelled,
      _ => l10n.disputeStatusOpen,
    };

String _outcomeLabel(AppLocalizations l10n, String outcome) =>
    switch (outcome) {
      DisputeOutcome.forOpener => l10n.disputeOutcomeForOpener,
      DisputeOutcome.againstRespondent => l10n.disputeOutcomeAgainstRespondent,
      DisputeOutcome.split => l10n.disputeOutcomeSplit,
      DisputeOutcome.dismissed => l10n.disputeOutcomeDismissed,
      _ => l10n.disputeOutcomePending,
    };

String _reasonLabel(AppLocalizations l10n, String reason) => switch (reason) {
      DisputeReason.notPaid => l10n.disputeReasonNotPaid,
      DisputeReason.underpaid => l10n.disputeReasonUnderpaid,
      DisputeReason.workNotDone => l10n.disputeReasonWorkNotDone,
      DisputeReason.poorQuality => l10n.disputeReasonPoorQuality,
      DisputeReason.noShow => l10n.disputeReasonNoShow,
      DisputeReason.damagedProperty => l10n.disputeReasonDamagedProperty,
      DisputeReason.abusiveBehavior => l10n.disputeReasonAbusiveBehavior,
      _ => l10n.disputeReasonOther,
    };
