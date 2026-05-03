import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../models/job.dart';
import '../../models/offer.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/offer_provider.dart';
import '../../providers/repositories.dart';
import '../../services/api_client.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/snack.dart';
import 'offer_compose_sheet.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobDetailProvider(jobId));
    return Scaffold(
      appBar: AppBar(title: const Text('Ish tafsiloti')),
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
    final point = LatLng(job.location.latitude, job.location.longitude);
    final auth = ref.watch(authControllerProvider);
    final me = auth is AuthSignedIn ? auth.user : null;
    final isCreator = me != null && job.creatorId != null && me.id == job.creatorId;
    final isWorker = me?.roles.isWorker ?? false;
    final myAssignment = me == null
        ? null
        : job.assignments.where((a) => a.workerId == me.id).cast<JobAssignment?>().firstWhere((_) => true, orElse: () => null);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(jobDetailProvider(jobId).future),
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
                Chip(label: Text(job.category!), visualDensity: VisualDensity.compact),
              Chip(label: Text(job.urgency), visualDensity: VisualDensity.compact),
              Chip(label: Text(job.status), visualDensity: VisualDensity.compact),
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
                  _row(context, Icons.attach_money, 'Narx', job.displayPrice ?? '\u2014'),
                  if (job.address != null && job.address!.isNotEmpty)
                    _row(context, Icons.place_outlined, 'Manzil', job.address!),
                  if (job.scheduledFor != null)
                    _row(context, Icons.schedule, 'Sana',
                        DateFormat('dd MMM yyyy, HH:mm').format(job.scheduledFor!.toLocal())),
                  _row(context, Icons.group_outlined, 'Ustachilar soni', job.workersNeeded.toString()),
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
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          if (isWorker && !isCreator && job.status == 'open' && myAssignment == null)
            FilledButton.icon(
              onPressed: () async {
                if (job.creatorId == null) return;
                final ok = await OfferComposeSheet.show(
                  context,
                  jobId: jobId,
                  recipientId: job.creatorId!,
                  defaultPricingModel: job.pricingModel == 'negotiable'
                      ? 'fixed'
                      : job.pricingModel,
                  suggestedAmount: job.budget ?? job.hourlyRate,
                );
                if (ok == true) ref.invalidate(jobOffersProvider(jobId));
              },
              icon: const Icon(Icons.send),
              label: const Text('Taklif yuborish'),
            ),

          // --- Client view: list incoming offers ------------------------
          if (isCreator && job.status == 'open') ...[
            const SizedBox(height: 8),
            Text('Kelgan takliflar', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _OffersList(jobId: jobId, isCreator: true),
          ],

          // --- Worker view: my own offers on this job -------------------
          if (!isCreator && isWorker) ...[
            const SizedBox(height: 8),
            Text('Mening takliflarim', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _OffersList(jobId: jobId, isCreator: false, myUserId: me?.id),
          ],

          // --- Assignment lifecycle UI ---------------------------------
          if (myAssignment != null) ...[
            const SizedBox(height: 16),
            _AssignmentControls(
              assignment: myAssignment,
              isWorker: true,
              jobId: jobId,
            ),
          ],
          if (isCreator && job.assignments.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (final a in job.assignments)
              _AssignmentControls(
                assignment: a,
                isWorker: false,
                jobId: jobId,
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
}

class _OffersList extends ConsumerWidget {
  final String jobId;
  final bool isCreator;
  final String? myUserId;
  const _OffersList({required this.jobId, required this.isCreator, this.myUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobOffersProvider(jobId));
    return state.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text(
        e is ApiException ? e.message : 'Takliflarni olishda xato',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      data: (offers) {
        final relevant = isCreator
            ? offers
            : offers.where((o) => o.senderId == myUserId).toList();
        if (relevant.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Hozircha takliflar yo\u02bcq'),
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

  Future<void> _do(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      ref.invalidate(jobOffersProvider(widget.jobId));
      ref.invalidate(jobDetailProvider(widget.jobId));
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, 'Amal bajarilmadi', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    final theme = Theme.of(context);
    final repo = ref.read(offersRepositoryProvider);
    final fmt = NumberFormat.decimalPattern();
    final amountStr = o.amount != null
        ? '${fmt.format(o.amount)} ${o.currency}${o.pricingModel == 'hourly' ? '/soat' : ''}'
        : 'Kelishiladi';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(amountStr, style: theme.textTheme.titleMedium),
                ),
                Chip(
                  label: Text(o.status),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (o.note.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(o.note, style: theme.textTheme.bodyMedium),
            ],
            if (o.durationEstimateHours != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Taxmin: ${o.durationEstimateHours} soat',
                    style: theme.textTheme.bodySmall),
              ),
            if (o.isOpen) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.isCreator) ...[
                    TextButton(
                      onPressed: _busy ? null : () => _do(() => repo.decline(o.id)),
                      child: const Text('Rad etish'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _busy ? null : () => _do(() => repo.accept(o.id)),
                      child: const Text('Qabul qilish'),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: _busy ? null : () => _do(() => repo.withdraw(o.id)),
                      child: const Text('Qaytarib olish'),
                    ),
                  ],
                ],
              ),
            ],
            if (o.isAccepted)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () async {
                          // workerId must be the worker side of the offer.
                          final workerId = o.direction == 'worker_to_client'
                              ? o.senderId
                              : o.recipientId;
                          try {
                            final t = await ref
                                .read(chatRepositoryProvider)
                                .openThread(
                                  jobId: widget.jobId,
                                  workerId: workerId,
                                );
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            context.push('/threads/${t.id}', extra: 'Suhbat');
                          } on ApiException catch (e) {
                            if (mounted) showSnack(context, e.message, error: true);
                          }
                        },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Suhbatga o\u02bctish'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentControls extends ConsumerStatefulWidget {
  final JobAssignment assignment;
  final bool isWorker;
  final String jobId;
  const _AssignmentControls({
    required this.assignment,
    required this.isWorker,
    required this.jobId,
  });

  @override
  ConsumerState<_AssignmentControls> createState() => _AssignmentControlsState();
}

class _AssignmentControlsState extends ConsumerState<_AssignmentControls> {
  bool _busy = false;

  Future<void> _do(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(jobDetailProvider(widget.jobId));
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, 'Amal bajarilmadi', error: true);
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
    final theme = Theme.of(context);
    final repo = ref.read(assignmentsRepositoryProvider);

    final actions = <Widget>[];
    if (widget.isWorker) {
      if (a.arrivedAt == null) {
        actions.add(_btn('Yetib keldim', Icons.location_on, () async {
          final c = await _coords();
          await _do(() => repo.arrived(a.id, lat: c.lat, lng: c.lng));
        }));
      } else if (a.startedAt == null) {
        actions.add(_btn('Ishni boshladim', Icons.play_arrow, () async {
          final c = await _coords();
          await _do(() => repo.started(a.id, lat: c.lat, lng: c.lng));
        }));
      } else if (a.doneAt == null) {
        actions.add(_btn('Tugatdim', Icons.check, () async {
          final c = await _coords();
          await _do(() => repo.done(a.id, lat: c.lat, lng: c.lng));
        }));
      }
    } else {
      // Client confirms
      if (a.doneAt != null && a.completedAt == null) {
        actions.add(_btn('Tasdiqlash', Icons.verified,
            () => _do(() => repo.confirm(a.id))));
      }
    }

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
                    widget.isWorker ? 'Mening tayinlovim' : a.workerPhone,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(a.status),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            _stamp(theme, 'Yetib keldi', a.arrivedAt),
            _stamp(theme, 'Boshladi', a.startedAt),
            _stamp(theme, 'Tugatdi', a.doneAt),
            _stamp(theme, 'Tasdiqlandi', a.completedAt),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(children: [for (final w in actions) Expanded(child: w)]),
            ],
          ],
        ),
      ),
    );
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

  Widget _stamp(ThemeData theme, String label, DateTime? when) {
    if (when == null) return const SizedBox.shrink();
    final fmt = DateFormat('dd MMM, HH:mm');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$label: ${fmt.format(when.toLocal())}',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
