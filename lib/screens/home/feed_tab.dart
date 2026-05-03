import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../models/job.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
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
    final auth = ref.watch(authControllerProvider);
    final isWorker = auth is AuthSignedIn && auth.user.roles.isWorker;

    if (!isWorker) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lenta')),
        body: const _ActivateWorkerEmpty(),
      );
    }

    final feed = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lenta'),
        actions: [
          IconButton(
            tooltip: _view == _FeedView.list ? 'Xarita' : 'Ro‘yxat',
            icon: Icon(_view == _FeedView.list ? Icons.map_outlined : Icons.list),
            onPressed: () => setState(() {
              _view = _view == _FeedView.list ? _FeedView.map : _FeedView.list;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filtrlar',
            onPressed: () => _openFilters(context),
          ),
        ],
      ),
      body: AsyncStateView<List<JobMatch>>(
        state: feed,
        onRetry: _refresh,
        isEmpty: (m) => m.isEmpty,
        emptyView: const _FeedEmpty(),
        data: (matches) => _view == _FeedView.list
            ? _ListView(matches: matches, onRefresh: _refresh)
            : _MapView(matches: matches),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    final filters = ref.read(feedFiltersProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => _FiltersSheet(initial: filters, onApply: (f) {
        ref.read(feedFiltersProvider.notifier).state = f;
      }),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<JobMatch> matches;
  final Future<void> Function() onRefresh;
  const _ListView({required this.matches, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: matches.length,
        itemBuilder: (ctx, i) {
          final m = matches[i];
          return JobCard(
            job: m.job,
            distanceKm: m.distanceKm,
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
                point: LatLng(m.job.location.latitude, m.job.location.longitude),
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
          Text('Filtrlar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text('Qidiruv radiusi: ${_radius.toStringAsFixed(0)} km'),
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
            decoration: const InputDecoration(
              labelText: 'Kalit so‘z',
              hintText: 'masalan: santexnik',
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
            child: const Text('Qo‘llash'),
          ),
        ],
      ),
    );
  }
}

class _FeedEmpty extends StatelessWidget {
  const _FeedEmpty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text(
              'Hozircha sizga mos ish topilmadi.\nFiltrlarni o‘zgartirib ko‘ring.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivateWorkerEmpty extends ConsumerWidget {
  const _ActivateWorkerEmpty();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handyman_outlined, size: 56),
            const SizedBox(height: 12),
            Text(
              'Ish topish uchun ustachi profilini oching',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => GoRouter.of(context).push('/role'),
              child: const Text('Ustachi bo‘lish'),
            ),
          ],
        ),
      ),
    );
  }
}
