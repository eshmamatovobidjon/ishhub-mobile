import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/generated/app_localizations.dart';
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

  void _leaveStreetMode() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(streetModeProvider);
    final canPop = GoRouter.of(context).canPop();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/profile');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _leaveStreetMode,
          ),
          title: Text(l10n.streetModeTitle),
        ),
        body: AsyncStateView<WorkerProfile?>(
          state: state,
          onRetry: () => ref.read(streetModeProvider.notifier).refresh(),
          data: (profile) {
            if (profile == null) {
              return const _ActivateNeeded();
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
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _busy = true);
    try {
      final res = await ref.read(locationServiceProvider).currentPosition();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      switch (res.status) {
        case LocationStatus.ok:
          setState(() => _picked = res.point);
          break;
        case LocationStatus.denied:
          showSnack(context, l10n.streetPermissionDenied, error: true);
          break;
        case LocationStatus.deniedForever:
          showSnack(context, l10n.streetPermissionSettings, error: true);
          break;
        case LocationStatus.serviceDisabled:
          showSnack(context, l10n.streetServiceDisabled, error: true);
          break;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit({required bool on}) async {
    if (on && _picked == null) {
      showSnack(context, AppLocalizations.of(context).streetLocationRequired,
          error: true);
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
      final l10n = AppLocalizations.of(context);
      showSnack(context, on ? l10n.streetEnabled : l10n.streetDisabled);
    } on ApiException catch (e) {
      if (mounted) showSnack(context, e.message, error: true);
    } catch (_) {
      if (mounted) {
        showSnack(context, AppLocalizations.of(context).commonNetworkError,
            error: true);
      }
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
    final l10n = AppLocalizations.of(context);
    final center = picked != null
        ? LatLng(picked!.latitude, picked!.longitude)
        : const LatLng(41.3111, 69.2797); // Tashkent fallback

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatusBanner(profile: profile, radiusKm: radiusKm),
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                            .withValues(alpha: 0.15),
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
          label: Text(l10n.streetGetLocation),
        ),
        const SizedBox(height: 16),
        Text(l10n.streetSearchRadius(radiusKm.toStringAsFixed(1))),
        Slider(
          value: radiusKm,
          min: 0.5,
          max: 50,
          divisions: 99,
          onChanged: busy ? null : onRadiusChanged,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: profile.availableNow
              ? FilledButton.tonalIcon(
                  onPressed: busy ? null : () => onSubmit(on: false),
                  icon: const Icon(Icons.power_settings_new),
                  label: Text(l10n.streetTurnOff),
                )
              : FilledButton.icon(
                  onPressed: busy ? null : () => onSubmit(on: true),
                  icon: const Icon(Icons.directions_walk),
                  label: Text(l10n.streetTurnOn),
                ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final WorkerProfile profile;
  final double radiusKm;
  const _StatusBanner({required this.profile, required this.radiusKm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final active = profile.availableNow;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(active
                    ? l10n.streetActiveStatus
                    : l10n.streetInactiveStatus),
                const SizedBox(height: 2),
                Text(
                  profile.lastLocation == null
                      ? l10n.streetNoSavedLocation
                      : l10n.streetSavedLocation(radiusKm.toStringAsFixed(1)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (profile.lastLocationAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.streetLastUpdated(
                        _relativeTime(l10n, profile.lastLocationAt!)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(AppLocalizations l10n, DateTime value) {
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return l10n.timeNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
    return l10n.timeWeeksAgo((diff.inDays / 7).floor());
  }
}

class _ActivateNeeded extends ConsumerWidget {
  const _ActivateNeeded();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handyman_outlined, size: 56),
            const SizedBox(height: 12),
            Text(
              l10n.streetActivateWorkerNeeded,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.push('/worker-setup?returnTo=/street-mode'),
              child: Text(l10n.streetActivateWorker),
            ),
          ],
        ),
      ),
    );
  }
}
