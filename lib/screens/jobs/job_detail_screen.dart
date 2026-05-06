import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/job.dart';
import '../../models/offer.dart';
import '../../models/payment.dart';
import '../../providers/auth_provider.dart';
import '../../providers/closeout_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/offer_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/snack.dart';
import '../closeout/closeout_args.dart';
import 'offer_compose_sheet.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(jobDetailProvider(jobId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetailTitle)),
      body: AsyncStateView<Job>(
        state: state,
        onRetry: () => ref.refresh(jobDetailProvider(jobId).future),
        data: (job) => _JobDetailView(job: job, jobId: jobId),
      ),
    );
  }
}

class _JobDetailView extends ConsumerWidget {
  final Job job;
  final String jobId;
  const _JobDetailView({required this.job, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final point = LatLng(job.location.latitude, job.location.longitude);
    final auth = ref.watch(authControllerProvider);
    final me = auth is AuthSignedIn ? auth.user : null;
    final isCreator =
        me != null && job.creatorId != null && me.id == job.creatorId;
    final isWorker = me?.roles.isWorker ?? false;
    final myAssignment = me == null
        ? null
        : job.assignments
            .where((a) => a.workerId == me.id)
            .cast<JobAssignment?>()
            .firstWhere((_) => true, orElse: () => null);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(jobOffersProvider(jobId));
        ref.invalidate(jobDetailProvider(jobId));
        await Future.wait([
          ref.read(jobDetailProvider(jobId).future),
          ref.read(jobOffersProvider(jobId).future),
        ]);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(job.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (job.category != null)
                Chip(
                    label: Text(_categoryLabel(l10n, job.category!)),
                    visualDensity: VisualDensity.compact),
              Chip(
                  label: Text(_urgencyLabel(l10n, job.urgency)),
                  visualDensity: VisualDensity.compact),
              Chip(
                  label: Text(_statusLabel(l10n, job.status)),
                  visualDensity: VisualDensity.compact),
            ],
          ),
          const SizedBox(height: 16),
          if (job.description != null && job.description!.isNotEmpty) ...[
            Text(job.description!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(context, Icons.attach_money, l10n.jobDetailPrice,
                      job.displayPrice ?? '\u2014'),
                  if (job.pricingModel == 'negotiable')
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 32),
                      child: Text(
                        l10n.jobDetailNegotiablePrice,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  if (job.address != null && job.address!.isNotEmpty)
                    _row(context, Icons.place_outlined, l10n.jobDetailAddress,
                        job.address!),
                  if (job.scheduledFor != null)
                    _row(
                        context,
                        Icons.schedule,
                        l10n.jobDetailDate,
                        DateFormat('dd MMM yyyy, HH:mm')
                            .format(job.scheduledFor!.toLocal())),
                  _row(
                      context,
                      Icons.group_outlined,
                      l10n.jobDetailWorkersNeeded,
                      job.workersNeeded.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(initialCenter: point, initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'uz.ishhub.app',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      point: point,
                      width: 44,
                      height: 44,
                      child: Icon(Icons.location_on,
                          size: 36, color: theme.colorScheme.primary),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Worker primary action: send / view offer -----------------
          if (isWorker &&
              !isCreator &&
              (job.status == 'posted' || job.status == 'assigned') &&
              myAssignment == null)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  if (job.creatorId == null) return;
                  final ok = await OfferComposeSheet.show(
                    context,
                    jobId: jobId,
                    recipientId: job.creatorId!,
                    jobTitle: job.title,
                    jobPriceLabel: job.displayPrice,
                    defaultPricingModel: job.pricingModel == 'negotiable'
                        ? 'fixed'
                        : job.pricingModel,
                    suggestedAmount: job.budget ?? job.hourlyRate,
                  );
                  if (ok == true) ref.invalidate(jobOffersProvider(jobId));
                },
                icon: const Icon(Icons.send),
                label: Text(l10n.offerComposeTitle),
              ),
            ),

          // --- Client view: list incoming offers ------------------------
          if (isCreator &&
              (job.status == 'posted' || job.status == 'assigned')) ...[
            const SizedBox(height: 8),
            Text(l10n.jobDetailIncomingOffers,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _OffersList(jobId: jobId, isCreator: true),
          ],

          // --- Worker view: my own offers on this job -------------------
          if (!isCreator && isWorker) ...[
            const SizedBox(height: 8),
            Text(l10n.jobDetailMyOffers, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _OffersList(jobId: jobId, isCreator: false, myUserId: me?.id),
          ],

          // --- Assignment lifecycle UI ---------------------------------
          if (myAssignment != null) ...[
            const SizedBox(height: 16),
            _JobDisputeBanner(jobId: jobId),
            _AssignmentControls(
              job: job,
              assignment: myAssignment,
              isWorker: true,
              jobId: jobId,
              currentUserId: me?.id,
            ),
          ],
          if (isCreator && job.assignments.isNotEmpty) ...[
            const SizedBox(height: 16),
            _JobDisputeBanner(jobId: jobId),
            for (final a in job.assignments)
              _AssignmentControls(
                job: job,
                assignment: a,
                isWorker: false,
                jobId: jobId,
                currentUserId: me.id,
              ),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      'cleaning' => l10n.categoryCleaning,
      'construction' => l10n.categoryConstruction,
      'repair' => l10n.categoryRepair,
      'delivery' => l10n.categoryDelivery,
      'farming' => l10n.categoryFarming,
      'gardening' => l10n.categoryGardening,
      'painting' => l10n.categoryPainting,
      'cooking' => l10n.categoryCooking,
      'teaching' => l10n.categoryTeaching,
      'design' => l10n.categoryDesign,
      'loading' => l10n.categoryLoading,
      _ => l10n.categoryOther,
    };
  }

  String _urgencyLabel(AppLocalizations l10n, String urgency) {
    return switch (urgency) {
      'urgent' => l10n.urgencyUrgent,
      'today' => l10n.urgencyToday,
      _ => l10n.urgencyFlexible,
    };
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    return _statusLabelFor(l10n, status);
  }
}

class _OffersList extends ConsumerWidget {
  final String jobId;
  final bool isCreator;
  final String? myUserId;
  const _OffersList(
      {required this.jobId, required this.isCreator, this.myUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(jobOffersProvider(jobId));
    return state.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text(
        e is ApiException ? e.message : l10n.jobDetailOffersError,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      data: (offers) {
        final relevant = isCreator
            ? offers
            : offers.where((o) => o.senderId == myUserId).toList();
        if (relevant.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.jobDetailNoOffers),
          );
        }
        return Column(
          children: [
            for (final o in relevant)
              _OfferCard(
                offer: o,
                jobId: jobId,
                isCreator: isCreator,
                myUserId: myUserId,
              ),
          ],
        );
      },
    );
  }
}

class _OfferCard extends ConsumerStatefulWidget {
  final Offer offer;
  final String jobId;
  final bool isCreator;
  final String? myUserId;
  const _OfferCard({
    required this.offer,
    required this.jobId,
    required this.isCreator,
    required this.myUserId,
  });

  @override
  ConsumerState<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<_OfferCard> {
  bool _busy = false;

  Future<void> _do(
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      _invalidateJobWorkState(ref, widget.jobId);
      if (successMessage != null) showSnack(context, successMessage);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).jobDetailActionFailed,
            error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openChat(Offer o) async {
    final l10n = AppLocalizations.of(context);
    final workerId =
        o.direction == 'worker_to_client' ? o.senderId : o.recipientId;
    try {
      final t = await ref.read(chatRepositoryProvider).openThread(
            jobId: widget.jobId,
            workerId: workerId,
          );
      if (!mounted) return;
      await context.push('/threads/${t.id}', extra: l10n.chatTitle);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final repo = ref.read(offersRepositoryProvider);
    final fmt = NumberFormat.decimalPattern();
    final worker = o.workerSummary;
    final workerName = (worker?.name?.trim().isNotEmpty ?? false)
        ? worker!.name!.trim()
        : l10n.offerApplicantUnnamed;
    final trust = worker?.trustScore;
    final profile = worker?.workerProfile;
    final skills = profile?.skills ?? const [];
    final location = [worker?.district, worker?.city]
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .join(', ');
    final amountStr = o.amount != null
        ? '${fmt.format(o.amount)} ${o.currency}${o.pricingModel == 'hourly' ? l10n.offerPerHourSuffix : ''}'
        : l10n.pricingNegotiable;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isCreator) ...[
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: worker?.avatarUrl == null
                        ? null
                        : NetworkImage(worker!.avatarUrl!),
                    child: worker?.avatarUrl == null
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCreator ? workerName : amountStr,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (widget.isCreator) ...[
                        const SizedBox(height: 2),
                        Text(amountStr, style: theme.textTheme.bodyMedium),
                        if (location.isNotEmpty)
                          Text(location, style: theme.textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                Chip(
                  label: Text(_statusLabelFor(l10n, o.status)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (widget.isCreator) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _miniChip(
                    context,
                    Icons.shield_outlined,
                    trust == null || trust.ratingCount < 3
                        ? l10n.offerTrustNew
                        : l10n.offerTrustScore(trust.score.toStringAsFixed(0)),
                  ),
                  if (trust != null)
                    _miniChip(
                      context,
                      Icons.reviews_outlined,
                      l10n.offerTrustRatings(trust.ratingCount),
                    ),
                  if (trust != null)
                    _miniChip(
                      context,
                      Icons.task_alt,
                      l10n.offerTrustCompleted(trust.completedJobs),
                    ),
                  if (profile?.availableNow ?? false)
                    _miniChip(
                      context,
                      Icons.near_me_outlined,
                      l10n.offerAvailableNow,
                    ),
                ],
              ),
              if (skills.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final item in skills.take(4))
                      Chip(
                        label: Text(item.skill.name),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ],
            if (o.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(o.note, style: theme.textTheme.bodyMedium),
            ],
            if (o.durationEstimateHours != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.offerDurationEstimate(
                    o.durationEstimateHours.toString(),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            if (o.isOpen) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    if (widget.isCreator) ...[
                      TextButton.icon(
                        onPressed: _busy ? null : () => _openChat(o),
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: Text(l10n.offerOpenChat),
                      ),
                      TextButton(
                        onPressed:
                            _busy ? null : () => _do(() => repo.decline(o.id)),
                        child: Text(l10n.offerDecline),
                      ),
                      FilledButton(
                        onPressed: _busy
                            ? null
                            : () => _do(
                                  () => repo.accept(o.id),
                                  successMessage:
                                      l10n.offerAcceptedAssignmentReady,
                                ),
                        child: Text(l10n.offerAccept),
                      ),
                    ] else ...[
                      TextButton(
                        onPressed:
                            _busy ? null : () => _do(() => repo.withdraw(o.id)),
                        child: Text(l10n.offerWithdraw),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (o.isAccepted)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _openChat(o),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(l10n.offerOpenChat),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.outline),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _AssignmentControls extends ConsumerStatefulWidget {
  final Job job;
  final JobAssignment assignment;
  final bool isWorker;
  final String jobId;
  final String? currentUserId;
  const _AssignmentControls({
    required this.job,
    required this.assignment,
    required this.isWorker,
    required this.jobId,
    required this.currentUserId,
  });

  @override
  ConsumerState<_AssignmentControls> createState() =>
      _AssignmentControlsState();
}

class _AssignmentControlsState extends ConsumerState<_AssignmentControls> {
  bool _busy = false;

  Future<void> _do(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      _invalidateJobWorkState(ref, widget.jobId);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).jobDetailActionFailed,
            error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<({double? lat, double? lng})> _coords() async {
    try {
      final loc = await ref.read(locationServiceProvider).currentPosition();
      if (loc.point != null) {
        return (lat: loc.point!.latitude, lng: loc.point!.longitude);
      }
    } catch (_) {/* ignore */}
    return (lat: null, lng: null);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.assignment;
    final payment = a.payment;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final repo = ref.read(assignmentsRepositoryProvider);

    final actions = <Widget>[];
    if (widget.isWorker) {
      if (a.arrivedAt == null) {
        actions.add(
            _btn(l10n.assignmentArrivedAction, Icons.location_on, () async {
          final c = await _coords();
          await _do(() => repo.arrived(a.id, lat: c.lat, lng: c.lng));
        }));
      } else if (a.startedAt == null) {
        actions
            .add(_btn(l10n.assignmentStartedAction, Icons.play_arrow, () async {
          final c = await _coords();
          await _do(() => repo.started(a.id, lat: c.lat, lng: c.lng));
        }));
      } else if (a.doneAt == null) {
        actions.add(_btn(l10n.assignmentDoneAction, Icons.check, () async {
          final c = await _coords();
          await _do(() => repo.done(a.id, lat: c.lat, lng: c.lng));
        }));
      }
    } else {
      // Client confirms
      if (a.doneAt != null && a.completedAt == null) {
        actions.add(_btn(
          l10n.assignmentConfirmAction,
          Icons.verified,
          () => _do(() => repo.confirm(a.id)),
        ));
      }
    }

    final closeoutArgs = AssignmentCloseoutArgs(
      job: widget.job,
      assignment: a,
      isWorker: widget.isWorker,
    );
    final canRecordPayment =
        !widget.isWorker && a.completedAt != null && payment == null;
    final canConfirmPayment =
        widget.isWorker && payment?.status == PaymentStatus.recorded;
    final canRate = a.completedAt != null &&
        payment != null &&
        payment.status != PaymentStatus.disputed &&
        widget.currentUserId != null &&
        !a.hasRated(widget.currentUserId!);
    final canOpenDispute = a.completedAt != null || a.doneAt != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isWorker ? l10n.assignmentMine : a.workerPhone,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(_statusLabelFor(l10n, a.status)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            _stamp(theme, l10n, l10n.assignmentArrivedStamp, a.arrivedAt),
            _stamp(theme, l10n, l10n.assignmentStartedStamp, a.startedAt),
            _stamp(theme, l10n, l10n.assignmentDoneStamp, a.doneAt),
            _stamp(theme, l10n, l10n.assignmentConfirmedStamp, a.completedAt),
            if (payment != null) ...[
              const SizedBox(height: 8),
              _PaymentSummary(payment: payment),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(children: [for (final w in actions) Expanded(child: w)]),
            ],
            if (canRecordPayment ||
                canConfirmPayment ||
                canRate ||
                canOpenDispute) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (canRecordPayment)
                    FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () => context.push(
                                '/assignments/${a.id}/payment',
                                extra: closeoutArgs,
                              ),
                      icon: const Icon(Icons.payments_outlined),
                      label: Text(l10n.paymentRecordAction),
                    ),
                  if (canConfirmPayment)
                    FilledButton.icon(
                      onPressed:
                          _busy ? null : () => _confirmPayment(payment!.id),
                      icon: const Icon(Icons.verified_outlined),
                      label: Text(l10n.paymentConfirmAction),
                    ),
                  if (canRate)
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => context.push(
                                '/assignments/${a.id}/rate',
                                extra: closeoutArgs,
                              ),
                      icon: const Icon(Icons.star_outline),
                      label: Text(l10n.ratingSubmitAction),
                    ),
                  if (canOpenDispute)
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => context.push(
                                '/jobs/${widget.jobId}/disputes/new',
                                extra: closeoutArgs,
                              ),
                      icon: const Icon(Icons.report_problem_outlined),
                      label: Text(l10n.disputeOpenAction),
                    ),
                  if (widget.isWorker &&
                      payment?.status == PaymentStatus.recorded)
                    TextButton.icon(
                      onPressed:
                          _busy ? null : () => _disputePayment(payment!.id),
                      icon: const Icon(Icons.gavel_outlined),
                      label: Text(l10n.paymentDisputeAction),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPayment(String paymentId) async {
    await _do(() async {
      await ref.read(paymentsRepositoryProvider).confirm(paymentId);
    });
  }

  Future<void> _disputePayment(String paymentId) async {
    final reason = await _PaymentDisputeSheet.show(context);
    if (reason == null) return;
    await _do(() async {
      await ref
          .read(paymentsRepositoryProvider)
          .dispute(paymentId, reason: reason);
    });
  }

  Widget _btn(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilledButton.icon(
        onPressed: _busy ? null : onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  Widget _stamp(
      ThemeData theme, AppLocalizations l10n, String label, DateTime? when) {
    if (when == null) return const SizedBox.shrink();
    final fmt = DateFormat('dd MMM, HH:mm');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        l10n.assignmentStamp(label, fmt.format(when.toLocal())),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  final Payment payment;
  const _PaymentSummary({required this.payment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amount = NumberFormat.decimalPattern().format(payment.amount);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments_outlined, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                '$amount ${payment.currency} · ${_paymentStatusLabel(l10n, payment.status)}'),
          ),
        ],
      ),
    );
  }
}

class _JobDisputeBanner extends ConsumerWidget {
  final String jobId;
  const _JobDisputeBanner({required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobDisputesProvider(jobId));
    final l10n = AppLocalizations.of(context);
    return state.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        final dispute = items.first;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
            child: ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: Text(l10n.disputeBannerTitle),
              subtitle: Text(_statusLabelFor(l10n, dispute.status)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/disputes/${dispute.id}'),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PaymentDisputeSheet extends StatefulWidget {
  const _PaymentDisputeSheet();

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _PaymentDisputeSheet(),
    );
  }

  @override
  State<_PaymentDisputeSheet> createState() => _PaymentDisputeSheetState();
}

class _PaymentDisputeSheetState extends State<_PaymentDisputeSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.paymentDisputeTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration:
                InputDecoration(labelText: l10n.paymentDisputeReasonLabel),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
            child: Text(l10n.paymentDisputeSubmit),
          ),
        ],
      ),
    );
  }
}

String _paymentStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      PaymentStatus.confirmed => l10n.paymentStatusConfirmed,
      PaymentStatus.disputed => l10n.paymentStatusDisputed,
      _ => l10n.paymentStatusRecorded,
    };

void _invalidateJobWorkState(WidgetRef ref, String jobId) {
  ref.invalidate(jobDetailProvider(jobId));
  ref.invalidate(jobOffersProvider(jobId));
  ref.invalidate(jobDisputesProvider(jobId));
  ref.invalidate(feedProvider);
  ref.invalidate(workerAssignmentsProvider('active'));
  ref.invalidate(workerAssignmentsProvider('history'));
  ref.invalidate(myJobsProvider);
}

String _statusLabelFor(AppLocalizations l10n, String status) {
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
    'pending' => l10n.statusPending,
    'accepted' => l10n.statusAccepted,
    'declined' => l10n.statusDeclined,
    'withdrawn' => l10n.statusWithdrawn,
    'arrived' => l10n.statusArrived,
    'started' => l10n.statusStarted,
    'done' => l10n.statusDone,
    'confirmed' => l10n.statusConfirmed,
    'ai_triaged' => l10n.disputeStatusAiTriaged,
    'under_review' => l10n.disputeStatusUnderReview,
    'resolved' => l10n.disputeStatusResolved,
    _ => status,
  };
}
