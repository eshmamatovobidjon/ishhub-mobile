import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/job.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../widgets/job_card.dart';
import '../../widgets/notification_bell.dart';

class JobsTab extends ConsumerWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final isWorker = auth is AuthSignedIn && auth.user.roles.isWorker;

    return DefaultTabController(
      length: isWorker ? 3 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isWorker ? l10n.jobsHubTitle : l10n.jobsMineTitle),
          actions: const [NotificationBell()],
          bottom: isWorker
              ? TabBar(
                  tabs: [
                    Tab(text: l10n.jobsTabActiveWork),
                    Tab(text: l10n.jobsTabPostedByMe),
                    Tab(text: l10n.jobsTabHistory),
                  ],
                )
              : null,
        ),
        body: isWorker
            ? const TabBarView(
                children: [
                  _AssignmentsList(scope: 'active'),
                  _PostedJobsList(),
                  _AssignmentsList(scope: 'history'),
                ],
              )
            : const _PostedJobsList(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/jobs/new'),
          icon: const Icon(Icons.add),
          label: Text(l10n.jobsNew),
        ),
      ),
    );
  }
}

class _AssignmentsList extends ConsumerWidget {
  final String scope;
  const _AssignmentsList({required this.scope});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(workerAssignmentsProvider(scope));
    return RefreshIndicator(
      onRefresh: () async =>
          ref.refresh(workerAssignmentsProvider(scope).future),
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorList(message: l10n.jobsError(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyList(
              icon: scope == 'active'
                  ? Icons.assignment_turned_in_outlined
                  : Icons.history_outlined,
              message: scope == 'active'
                  ? l10n.jobsActiveEmpty
                  : l10n.jobsHistoryEmpty,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            itemBuilder: (_, i) => _AssignmentWorkCard(item: items[i]),
          );
        },
      ),
    );
  }
}

class _PostedJobsList extends ConsumerWidget {
  const _PostedJobsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(myJobsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(myJobsProvider.future),
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorList(message: l10n.jobsError(e.toString())),
        data: (jobs) {
          if (jobs.isEmpty) {
            return _EmptyList(
              icon: Icons.post_add_outlined,
              message: l10n.jobsPostedEmpty,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: jobs.length,
            itemBuilder: (_, i) {
              final job = jobs[i];
              return JobCard(
                job: job,
                onTap: () => context.push('/jobs/${job.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _AssignmentWorkCard extends StatelessWidget {
  final WorkerAssignment item;
  const _AssignmentWorkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final job = item.job;
    final assignment = item.assignment;
    final date = job.scheduledFor ?? job.createdAt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/jobs/${job.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title.isEmpty ? l10n.jobUntitled : job.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(_statusLabel(l10n, assignment.status)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _Meta(
                    icon: Icons.schedule_outlined,
                    label: DateFormat('dd MMM, HH:mm').format(date.toLocal()),
                  ),
                  if (job.displayPrice != null && job.displayPrice!.isNotEmpty)
                    _Meta(
                      icon: Icons.payments_outlined,
                      label: job.displayPrice!,
                    ),
                  _Meta(
                    icon: Icons.work_history_outlined,
                    label: _statusLabel(l10n, job.status),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ProgressRail(assignment: assignment),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.push('/jobs/${job.id}'),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.jobsOpenJob),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRail extends StatelessWidget {
  final JobAssignment assignment;
  const _ProgressRail({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final steps = [
      (l10n.assignmentArrivedStamp, assignment.arrivedAt != null),
      (l10n.assignmentStartedStamp, assignment.startedAt != null),
      (l10n.assignmentDoneStamp, assignment.doneAt != null),
      (l10n.assignmentConfirmedStamp, assignment.completedAt != null),
    ];
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Icon(
                  steps[i].$2 ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: steps[i].$2 ? scheme.primary : scheme.outline,
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].$1,
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (i != steps.length - 1)
            Container(
              width: 12,
              height: 1,
              color: steps[i].$2 ? scheme.primary : scheme.outlineVariant,
            ),
        ],
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Meta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptyList extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyList({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 88),
        Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class _ErrorList extends StatelessWidget {
  final String message;
  const _ErrorList({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 88),
        Icon(Icons.error_outline,
            size: 56, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

String _statusLabel(AppLocalizations l10n, String status) {
  return switch (status) {
    'draft' => l10n.statusDraft,
    'open' => l10n.statusOpen,
    'posted' => l10n.statusPosted,
    'matching' => l10n.statusMatching,
    'assigned' => l10n.statusAssigned,
    'in_progress' => l10n.statusInProgress,
    'completed' => l10n.statusCompleted,
    'cancelled' => l10n.statusCancelled,
    'disputed' => l10n.statusDisputed,
    'done' => l10n.statusDone,
    _ => status,
  };
}
