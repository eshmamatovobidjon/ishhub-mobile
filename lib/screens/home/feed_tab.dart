import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/geo.dart';
import '../../models/job.dart';
import '../../models/nearby_worker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../providers/worker_search_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/notification_bell.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/job_card.dart';

enum _FeedView { list, map }

class FeedTab extends ConsumerStatefulWidget {
  const FeedTab({super.key});

  @override
  ConsumerState<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<FeedTab> {
  _FeedView _view = _FeedView.list;

  Future<void> _refresh() async => ref.refresh(feedProvider.future);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final isWorker = auth is AuthSignedIn && auth.user.roles.isWorker;

    if (!isWorker) {
      return const _ClientFindWorkersTab();
    }

    final feed = ref.watch(feedProvider);
    final activeAssignments = ref.watch(workerAssignmentsProvider('active'));
    final activeCount = activeAssignments.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navFeed),
        actions: [
          IconButton(
            tooltip: _view == _FeedView.list
                ? l10n.feedMapTooltip
                : l10n.feedListTooltip,
            icon:
                Icon(_view == _FeedView.list ? Icons.map_outlined : Icons.list),
            onPressed: () => setState(() {
              _view = _view == _FeedView.list ? _FeedView.map : _FeedView.list;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l10n.feedFiltersTooltip,
            onPressed: () => _openFilters(context),
          ),
          const NotificationBell(),
        ],
      ),
      body: AsyncStateView<List<JobMatch>>(
        state: feed,
        onRetry: _refresh,
        isEmpty: (m) => m.isEmpty,
        emptyView: _FeedEmpty(activeCount: activeCount),
        data: (matches) => _view == _FeedView.list
            ? _ListView(
                matches: matches,
                activeCount: activeCount,
                onRefresh: _refresh,
              )
            : _MapView(matches: matches),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    final filters = ref.read(feedFiltersProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => _FiltersSheet(
          initial: filters,
          onApply: (f) {
            ref.read(feedFiltersProvider.notifier).state = f;
          }),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<JobMatch> matches;
  final int activeCount;
  final Future<void> Function() onRefresh;
  const _ListView({
    required this.matches,
    required this.activeCount,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final hasFallbackMatches = matches.any((m) => !m.distanceKnown);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: matches.length +
            (activeCount > 0 ? 1 : 0) +
            (hasFallbackMatches ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (activeCount > 0 && i == 0) {
            return _ActiveWorkBanner(activeCount: activeCount);
          }
          final fallbackIndex = activeCount > 0 ? 1 : 0;
          if (hasFallbackMatches && i == fallbackIndex) {
            return const _StreetModePrompt();
          }
          final index = i -
              (activeCount > 0 ? 1 : 0) -
              (hasFallbackMatches && i > fallbackIndex ? 1 : 0);
          final m = matches[index];
          return JobCard(
            job: m.job,
            distanceKm: m.distanceKm,
            distanceKnown: m.distanceKnown,
            skillOverlap: m.skillOverlap,
            matchScore: m.score,
            showOfferHint: true,
            onTap: () => ctx.push('/jobs/${m.job.id}'),
          );
        },
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final List<JobMatch> matches;
  const _MapView({required this.matches});

  @override
  Widget build(BuildContext context) {
    final first = matches.first.job.location;
    final center = LatLng(first.latitude, first.longitude);
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'uz.ishhub.app',
        ),
        MarkerLayer(
          markers: [
            for (final m in matches)
              Marker(
                point:
                    LatLng(m.job.location.latitude, m.job.location.longitude),
                width: 44,
                height: 44,
                child: GestureDetector(
                  onTap: () => _showSheet(context, m),
                  child: Icon(
                    Icons.location_on,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showSheet(BuildContext context, JobMatch m) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: JobCard(
          job: m.job,
          distanceKm: m.distanceKm,
          distanceKnown: m.distanceKnown,
          skillOverlap: m.skillOverlap,
          matchScore: m.score,
          showOfferHint: true,
          onTap: () {
            Navigator.of(context).pop();
            context.push('/jobs/${m.job.id}');
          },
        ),
      ),
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  final FeedFilters initial;
  final void Function(FeedFilters) onApply;
  const _FiltersSheet({required this.initial, required this.onApply});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late double _radius = widget.initial.radiusKm;
  late final TextEditingController _q =
      TextEditingController(text: widget.initial.query ?? '');

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.feedFiltersTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(l10n.feedSearchRadius(_radius.toStringAsFixed(0))),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_radius.toStringAsFixed(0)} km',
            onChanged: (v) => setState(() => _radius = v),
          ),
          TextField(
            controller: _q,
            decoration: InputDecoration(
              labelText: l10n.feedKeywordLabel,
              hintText: l10n.feedKeywordHint,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              widget.onApply(FeedFilters(
                radiusKm: _radius,
                query: _q.text.trim().isEmpty ? null : _q.text.trim(),
                category: widget.initial.category,
              ));
              Navigator.of(context).pop();
            },
            child: Text(l10n.feedApplyFilters),
          ),
        ],
      ),
    );
  }
}

class _FeedEmpty extends StatelessWidget {
  final int activeCount;
  const _FeedEmpty({required this.activeCount});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (activeCount > 0) ...[
              _ActiveWorkBanner(activeCount: activeCount),
              const SizedBox(height: 20),
            ],
            Icon(Icons.search_off,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              l10n.feedEmpty,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientFindWorkersTab extends ConsumerStatefulWidget {
  const _ClientFindWorkersTab();

  @override
  ConsumerState<_ClientFindWorkersTab> createState() =>
      _ClientFindWorkersTabState();
}

class _ClientFindWorkersTabState extends ConsumerState<_ClientFindWorkersTab> {
  bool _hydrated = false;
  bool _locating = false;
  LocationStatus? _locationStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hydrated) {
      _hydrated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateOrigin());
    }
  }

  Future<void> _hydrateOrigin() async {
    final auth = ref.read(authControllerProvider);
    final saved = auth is AuthSignedIn ? auth.user.location : null;
    await _useCurrentLocation(fallback: saved, quiet: true);
  }

  Future<void> _useCurrentLocation(
      {GeoPoint? fallback, bool quiet = false}) async {
    if (!mounted) return;
    setState(() {
      _locating = true;
      _locationStatus = null;
    });
    try {
      final res = await ref.read(locationServiceProvider).currentPosition();
      if (!mounted) return;
      if (res.status == LocationStatus.ok && res.point != null) {
        ref.read(workerSearchOriginProvider.notifier).state = res.point;
        setState(() => _locationStatus = res.status);
        return;
      }
      if (fallback != null) {
        ref.read(workerSearchOriginProvider.notifier).state = fallback;
      }
      setState(() => _locationStatus = res.status);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(nearbyWorkersProvider);
    await ref.read(nearbyWorkersProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final origin = ref.watch(workerSearchOriginProvider);
    final filters = ref.watch(workerSearchFiltersProvider);
    final workers = ref.watch(nearbyWorkersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.findWorkersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l10n.feedFiltersTooltip,
            onPressed: () => _openWorkerFilters(context),
          ),
          const NotificationBell(),
        ],
      ),
      body: origin == null
          ? _FindWorkersLocationPrompt(
              locating: _locating,
              status: _locationStatus,
              onUseLocation: () => _useCurrentLocation(),
            )
          : Column(
              children: [
                _FindWorkersHeader(
                  origin: origin,
                  filters: filters,
                  locating: _locating,
                  onUseLocation: () => _useCurrentLocation(),
                ),
                Expanded(
                  child: AsyncStateView<List<NearbyWorker>>(
                    state: workers,
                    onRetry: _refresh,
                    isEmpty: (items) => items.isEmpty,
                    emptyView: _FindWorkersEmpty(onRefresh: _refresh),
                    data: (items) => RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: items.length + 1,
                        itemBuilder: (ctx, index) {
                          if (index == 0) {
                            return _WorkerResultSectionTitle(
                                count: items.length);
                          }
                          final worker = items[index - 1];
                          return _NearbyWorkerCard(
                            worker: worker,
                            onTap: () => _showWorkerSheet(context, worker),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _openWorkerFilters(BuildContext context) {
    final filters = ref.read(workerSearchFiltersProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _WorkerFiltersSheet(
        initial: filters,
        onApply: (value) {
          ref.read(workerSearchFiltersProvider.notifier).state = value;
        },
      ),
    );
  }

  void _showWorkerSheet(BuildContext context, NearbyWorker worker) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _NearbyWorkerSheet(worker: worker),
    );
  }
}

class _FindWorkersHeader extends StatelessWidget {
  final GeoPoint origin;
  final WorkerSearchFilters filters;
  final bool locating;
  final VoidCallback onUseLocation;

  const _FindWorkersHeader({
    required this.origin,
    required this.filters,
    required this.locating,
    required this.onUseLocation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Icon(Icons.near_me_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.findWorkersHeader,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.findWorkersHeaderSubtitle(
                      filters.radiusKm.toStringAsFixed(0),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: locating ? null : onUseLocation,
              icon: locating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.gps_fixed),
              tooltip: l10n.findWorkersUseCurrentLocation,
            ),
          ],
        ),
      ),
    );
  }
}

class _FindWorkersLocationPrompt extends StatelessWidget {
  final bool locating;
  final LocationStatus? status;
  final VoidCallback onUseLocation;

  const _FindWorkersLocationPrompt({
    required this.locating,
    required this.status,
    required this.onUseLocation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_searching,
                size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              l10n.findWorkersLocationTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _locationMessage(l10n, status),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: locating ? null : onUseLocation,
              icon: locating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.gps_fixed),
              label: Text(l10n.findWorkersUseCurrentLocation),
            ),
          ],
        ),
      ),
    );
  }

  String _locationMessage(AppLocalizations l10n, LocationStatus? status) {
    return switch (status) {
      LocationStatus.denied => l10n.streetPermissionDenied,
      LocationStatus.deniedForever => l10n.streetPermissionSettings,
      LocationStatus.serviceDisabled => l10n.streetServiceDisabled,
      _ => l10n.findWorkersLocationSubtitle,
    };
  }
}

class _FindWorkersEmpty extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _FindWorkersEmpty({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 96),
          Icon(Icons.search_off,
              size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.findWorkersEmpty,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerResultSectionTitle extends StatelessWidget {
  final int count;
  const _WorkerResultSectionTitle({required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.findWorkersClosestNow,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(l10n.findWorkersCount(count)),
        ],
      ),
    );
  }
}

class _NearbyWorkerCard extends StatelessWidget {
  final NearbyWorker worker;
  final VoidCallback onTap;

  const _NearbyWorkerCard({required this.worker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = _workerName(l10n, worker);
    final skill =
        worker.topSkills.isNotEmpty ? worker.topSkills.first.skill.name : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(_initial(name)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _TrustPill(worker: worker),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _WorkerMeta(
                          icon: Icons.place_outlined,
                          label: l10n.findWorkersDistance(
                            worker.distanceKm.toStringAsFixed(1),
                          ),
                        ),
                        if (skill != null)
                          _WorkerMeta(
                              icon: Icons.handyman_outlined, label: skill),
                        _WorkerMeta(
                          icon: Icons.radio_button_checked,
                          label: _freshnessLabel(l10n, worker),
                        ),
                      ],
                    ),
                    if (worker.locality != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        worker.locality!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (worker.profile.defaultRate != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.findWorkersRate(
                          worker.profile.defaultRate!.toStringAsFixed(0),
                          _rateUnit(l10n, worker.profile.defaultRateUnit),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  final NearbyWorker worker;
  const _TrustPill({required this.worker});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final score = worker.trustScore;
    final label = score == null || score.ratingCount < 3
        ? l10n.findWorkersNewBadge
        : l10n.findWorkersTrust(score.score.toStringAsFixed(0));
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}

class _WorkerMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WorkerMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _NearbyWorkerSheet extends StatelessWidget {
  final NearbyWorker worker;
  const _NearbyWorkerSheet({required this.worker});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = _workerName(l10n, worker);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          4,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Text(_initial(name)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        l10n.findWorkersDistance(
                          worker.distanceKm.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                ),
                _TrustPill(worker: worker),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in worker.topSkills)
                  Chip(label: Text(item.skill.name)),
              ],
            ),
            if (worker.profile.bio?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(worker.profile.bio!.trim()),
            ],
            const SizedBox(height: 12),
            _WorkerMeta(
              icon: Icons.radio_button_checked,
              label: _freshnessLabel(l10n, worker),
            ),
            if (worker.profile.defaultRate != null) ...[
              const SizedBox(height: 8),
              _WorkerMeta(
                icon: Icons.payments_outlined,
                label: l10n.findWorkersRate(
                  worker.profile.defaultRate!.toStringAsFixed(0),
                  _rateUnit(l10n, worker.profile.defaultRateUnit),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/jobs/new');
                },
                icon: const Icon(Icons.post_add_outlined),
                label: Text(l10n.findWorkersPostJobAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerFiltersSheet extends StatefulWidget {
  final WorkerSearchFilters initial;
  final ValueChanged<WorkerSearchFilters> onApply;

  const _WorkerFiltersSheet({required this.initial, required this.onApply});

  @override
  State<_WorkerFiltersSheet> createState() => _WorkerFiltersSheetState();
}

class _WorkerFiltersSheetState extends State<_WorkerFiltersSheet> {
  late double _radius = widget.initial.radiusKm;
  late final TextEditingController _q =
      TextEditingController(text: widget.initial.query ?? '');

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.findWorkersFiltersTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(l10n.feedSearchRadius(_radius.toStringAsFixed(0))),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_radius.toStringAsFixed(0)} km',
            onChanged: (v) => setState(() => _radius = v),
          ),
          TextField(
            controller: _q,
            decoration: InputDecoration(
              labelText: l10n.findWorkersSearchLabel,
              hintText: l10n.findWorkersSearchHint,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              widget.onApply(WorkerSearchFilters(
                radiusKm: _radius,
                query: _q.text.trim().isEmpty ? null : _q.text.trim(),
              ));
              Navigator.of(context).pop();
            },
            child: Text(l10n.feedApplyFilters),
          ),
        ],
      ),
    );
  }
}

String _freshnessLabel(AppLocalizations l10n, NearbyWorker worker) {
  return switch (worker.availabilityFreshness) {
    'fresh' => l10n.findWorkersFreshNow,
    'recent' => l10n.findWorkersFreshRecent,
    'stale' => l10n.findWorkersFreshStale,
    _ => l10n.findWorkersFreshUnknown,
  };
}

String _workerName(AppLocalizations l10n, NearbyWorker worker) {
  return worker.displayName.isNotEmpty
      ? worker.displayName
      : l10n.findWorkersUnnamedWorker;
}

String _initial(String value) => value.substring(0, 1).toUpperCase();

String _rateUnit(AppLocalizations l10n, String unit) {
  return unit == 'fixed' ? l10n.pricingFixed : l10n.pricingHourly;
}

class _StreetModePrompt extends StatelessWidget {
  const _StreetModePrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading:
              Icon(Icons.near_me_outlined, color: scheme.onSecondaryContainer),
          title: Text(
            l10n.feedStreetModePromptTitle,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
          subtitle: Text(
            l10n.feedStreetModePromptSubtitle,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
          trailing:
              Icon(Icons.chevron_right, color: scheme.onSecondaryContainer),
          onTap: () => context.go('/street-mode'),
        ),
      ),
    );
  }
}

class _ActiveWorkBanner extends StatelessWidget {
  final int activeCount;
  const _ActiveWorkBanner({required this.activeCount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Icon(Icons.assignment_turned_in_outlined,
              color: scheme.onPrimaryContainer),
          title: Text(
            l10n.feedActiveWorkTitle(activeCount),
            style: TextStyle(color: scheme.onPrimaryContainer),
          ),
          subtitle: Text(
            l10n.feedActiveWorkSubtitle,
            style: TextStyle(color: scheme.onPrimaryContainer),
          ),
          trailing: Icon(Icons.chevron_right, color: scheme.onPrimaryContainer),
          onTap: () => context.go('/jobs'),
        ),
      ),
    );
  }
}
