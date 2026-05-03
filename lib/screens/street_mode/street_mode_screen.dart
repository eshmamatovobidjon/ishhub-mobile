import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../models/geo.dart';
import '../../models/worker_profile.dart';
import '../../providers/repositories.dart';
import '../../providers/street_mode_provider.dart';
import '../../services/api_client.dart';
import '../../services/location_service.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/snack.dart';

class StreetModeScreen extends ConsumerStatefulWidget {
  const StreetModeScreen({super.key});

  @override
  ConsumerState<StreetModeScreen> createState() => _StreetModeScreenState();
}

class _StreetModeScreenState extends ConsumerState<StreetModeScreen> {
  GeoPoint? _picked;
  double _radiusKm = 5;
  bool _busy = false;
  bool _hydrated = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(streetModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ko\u2018chada rejim')),
      body: AsyncStateView<WorkerProfile?>(
        state: state,
        onRetry: () => ref.read(streetModeProvider.notifier).refresh(),
        data: (profile) {
          if (profile == null) {
            return _ActivateNeeded(
              onActivated: () =>
                  ref.read(streetModeProvider.notifier).refresh(),
            );
          }
          if (!_hydrated) {
            _picked = profile.lastLocation;
            if (profile.availableRadiusM > 0) {
              _radiusKm = profile.availableRadiusM / 1000;
            }
            _hydrated = true;
          }
          return _Editor(
            profile: profile,
            picked: _picked,
            radiusKm: _radiusKm,
            busy: _busy,
            onPickLocation: _useCurrentLocation,
            onRadiusChanged: (v) => setState(() => _radiusKm = v),
            onSubmit: ({required bool on}) => _submit(on: on),
          );
        },
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _busy = true);
    try {
      final res = await ref.read(locationServiceProvider).currentPosition();
      if (!mounted) return;
      switch (res.status) {
        case LocationStatus.ok:
          setState(() => _picked = res.point);
          break;
        case LocationStatus.denied:
          showSnack(context, 'Joylashuv ruxsati berilmadi', error: true);
          break;
        case LocationStatus.deniedForever:
          showSnack(context, 'Sozlamalardan ruxsat bering', error: true);
          break;
        case LocationStatus.serviceDisabled:
          showSnack(context, 'Joylashuv xizmati o\u2018chirilgan', error: true);
          break;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit({required bool on}) async {
    if (on && _picked == null) {
      showSnack(context, 'Avval joylashuvni tanlang', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(streetModeProvider.notifier).set(
            availableNow: on,
            radiusM: (_radiusKm * 1000).round(),
            latitude: _picked?.latitude,
            longitude: _picked?.longitude,
          );
      if (!mounted) return;
      showSnack(context,
          on ? 'Ko\u2018chada rejim yoqildi' : 'Rejim o\u2018chirildi');
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) showSnack(context, 'Tarmoq xatosi', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _Editor extends StatelessWidget {
  final WorkerProfile profile;
  final GeoPoint? picked;
  final double radiusKm;
  final bool busy;
  final VoidCallback onPickLocation;
  final ValueChanged<double> onRadiusChanged;
  final void Function({required bool on}) onSubmit;

  const _Editor({
    required this.profile,
    required this.picked,
    required this.radiusKm,
    required this.busy,
    required this.onPickLocation,
    required this.onRadiusChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final center = picked != null
        ? LatLng(picked!.latitude, picked!.longitude)
        : const LatLng(41.3111, 69.2797); // Tashkent fallback

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatusBanner(active: profile.availableNow),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              key: ValueKey(picked),
              options: MapOptions(initialCenter: center, initialZoom: 13),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'uz.ishhub.app',
                ),
                if (picked != null)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: center,
                        useRadiusInMeter: true,
                        radius: radiusKm * 1000,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15),
                        borderStrokeWidth: 1.5,
                        borderColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                if (picked != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 40,
                        height: 40,
                        child: Icon(Icons.my_location,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : onPickLocation,
          icon: const Icon(Icons.gps_fixed),
          label: const Text('Hozirgi joylashuvni olish'),
        ),
        const SizedBox(height: 16),
        Text('Qidiruv radiusi: ${radiusKm.toStringAsFixed(1)} km'),
        Slider(
          value: radiusKm,
          min: 0.5,
          max: 50,
          divisions: 99,
          onChanged: busy ? null : onRadiusChanged,
        ),
        const SizedBox(height: 16),
        if (profile.availableNow)
          FilledButton.tonalIcon(
            onPressed: busy ? null : () => onSubmit(on: false),
            icon: const Icon(Icons.power_settings_new),
            label: const Text('Rejimni o\u2018chirish'),
          )
        else
          FilledButton.icon(
            onPressed: busy ? null : () => onSubmit(on: true),
            icon: const Icon(Icons.directions_walk),
            label: const Text('Ko\u2018chada rejimni yoqish'),
          ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final bool active;
  const _StatusBanner({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(active ? Icons.radio_button_checked : Icons.radio_button_off),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              active
                  ? 'Hozir mijozlar sizni topa oladi'
                  : 'Rejim o\u2018chirilgan',
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivateNeeded extends ConsumerWidget {
  final VoidCallback onActivated;
  const _ActivateNeeded({required this.onActivated});

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
            const Text(
              'Bu funksiya uchun ustachi profilini oching',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                try {
                  await ref
                      .read(profileRepositoryProvider)
                      .activateWorker();
                  onActivated();
                } on ApiException catch (e) {
                  if (context.mounted) {
                    showSnack(context, e.message, error: true);
                  }
                }
              },
              child: const Text('Ochish'),
            ),
          ],
        ),
      ),
    );
  }
}
