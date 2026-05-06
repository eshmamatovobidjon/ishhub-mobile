import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/geo.dart';
import '../../models/skill.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/repositories.dart';
import '../../providers/skills_provider.dart';
import '../../providers/street_mode_provider.dart';
import '../../services/api_client.dart';
import '../../services/location_service.dart';

class WorkerSetupScreen extends ConsumerStatefulWidget {
  final String? returnTo;
  const WorkerSetupScreen({super.key, this.returnTo});

  @override
  ConsumerState<WorkerSetupScreen> createState() => _WorkerSetupScreenState();
}

class _WorkerSetupScreenState extends ConsumerState<WorkerSetupScreen> {
  final _bio = TextEditingController();
  final _rate = TextEditingController();
  final _search = TextEditingController();
  final Set<String> _selected = {};
  String _rateUnit = 'hourly';
  GeoPoint? _location;
  double _radiusKm = 5;
  bool _availableNow = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _bio.dispose();
    _rate.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final res = await ref.read(locationServiceProvider).currentPosition();
      if (!mounted) return;
      switch (res.status) {
        case LocationStatus.ok:
          setState(() => _location = res.point);
          break;
        case LocationStatus.denied:
          setState(() => _error = l10n.streetPermissionDenied);
          break;
        case LocationStatus.deniedForever:
          setState(() => _error = l10n.streetPermissionSettings);
          break;
        case LocationStatus.serviceDisabled:
          setState(() => _error = l10n.streetServiceDisabled);
          break;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_selected.isEmpty) {
      setState(() => _error = l10n.workerSetupSkillsRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final defaultRate = num.tryParse(_rate.text.trim());
      await ref.read(profileRepositoryProvider).activateWorker(
            bio: _bio.text.trim(),
            defaultRate: defaultRate,
            defaultRateUnit: _rateUnit,
            skillIds: _selected.toList(),
            availableNow: _availableNow && _location != null,
            radiusM: (_radiusKm * 1000).round(),
            latitude: _location?.latitude,
            longitude: _location?.longitude,
          );
      await ref.read(authControllerProvider.notifier).refreshUser();
      ref.invalidate(workerProfileProvider);
      ref.invalidate(streetModeProvider);
      ref.invalidate(mySkillsProvider);
      ref.invalidate(feedProvider);
      if (!mounted) return;
      final target =
          widget.returnTo?.isNotEmpty == true ? widget.returnTo! : '/feed';
      context.go(target);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = l10n.commonNetworkErrorRetry);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final skills = ref.watch(skillsCatalogProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.workerSetupTitle)),
      body: SafeArea(
        child: skills.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _SetupError(message: l10n.jobsError(e.toString())),
          data: (items) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.workerSetupHeadline,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(l10n.workerSetupSubtitle),
              const SizedBox(height: 20),
              TextField(
                controller: _search,
                decoration: InputDecoration(
                  labelText: l10n.workerSetupSkillSearchLabel,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              _SkillPicker(
                skills: items,
                selected: _selected,
                query: _search.text,
                onChanged: (id, selected) => setState(() {
                  if (selected) {
                    _selected.add(id);
                  } else {
                    _selected.remove(id);
                  }
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _bio,
                maxLines: 4,
                maxLength: 600,
                decoration: InputDecoration(
                  labelText: l10n.workerSetupBioLabel,
                  hintText: l10n.workerSetupBioHint,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _rate,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: l10n.workerSetupRateLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 132,
                    child: DropdownButtonFormField<String>(
                      initialValue: _rateUnit,
                      decoration: InputDecoration(
                          labelText: l10n.workerSetupRateUnitLabel),
                      items: [
                        DropdownMenuItem(
                            value: 'hourly', child: Text(l10n.pricingHourly)),
                        DropdownMenuItem(
                            value: 'fixed', child: Text(l10n.pricingFixed)),
                      ],
                      onChanged: (v) =>
                          setState(() => _rateUnit = v ?? 'hourly'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _AvailabilitySetupCard(
                location: _location,
                radiusKm: _radiusKm,
                availableNow: _availableNow,
                busy: _busy,
                onPickLocation: _useCurrentLocation,
                onRadiusChanged: (v) => setState(() => _radiusKm = v),
                onAvailableChanged: (v) => setState(() => _availableNow = v),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.verified_user_outlined),
                label: Text(l10n.workerSetupFinish),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilitySetupCard extends StatelessWidget {
  final GeoPoint? location;
  final double radiusKm;
  final bool availableNow;
  final bool busy;
  final VoidCallback onPickLocation;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<bool> onAvailableChanged;

  const _AvailabilitySetupCard({
    required this.location,
    required this.radiusKm,
    required this.availableNow,
    required this.busy,
    required this.onPickLocation,
    required this.onRadiusChanged,
    required this.onAvailableChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_walk),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.workerSetupAvailabilityTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(location == null
                ? l10n.workerSetupAvailabilitySubtitle
                : l10n.workerSetupLocationReady),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: busy ? null : onPickLocation,
              icon: const Icon(Icons.gps_fixed),
              label: Text(l10n.workerSetupUseLocation),
            ),
            const SizedBox(height: 12),
            Text(l10n.workerSetupRadius(radiusKm.toStringAsFixed(1))),
            Slider(
              value: radiusKm,
              min: 0.5,
              max: 50,
              divisions: 99,
              onChanged: busy ? null : onRadiusChanged,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: availableNow,
              onChanged: location == null || busy ? null : onAvailableChanged,
              title: Text(l10n.workerSetupAvailableNowTitle),
              subtitle: Text(location == null
                  ? l10n.workerSetupAvailableNowNeedsLocation
                  : l10n.workerSetupAvailableNowSubtitle),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillPicker extends StatelessWidget {
  final List<Skill> skills;
  final Set<String> selected;
  final String query;
  final void Function(String id, bool selected) onChanged;

  const _SkillPicker({
    required this.skills,
    required this.selected,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lower = query.trim().toLowerCase();
    final filtered = lower.isEmpty
        ? skills
        : skills.where((s) {
            return s.name.toLowerCase().contains(lower) ||
                s.nameEn.toLowerCase().contains(lower) ||
                s.nameRu.toLowerCase().contains(lower) ||
                s.nameUz.toLowerCase().contains(lower) ||
                s.slug.toLowerCase().contains(lower);
          }).toList();
    final grouped = <String, List<Skill>>{};
    for (final skill in filtered) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Text(
              _categoryLabel(AppLocalizations.of(context), entry.key),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in entry.value)
                FilterChip(
                  label: Text(skill.name),
                  selected: selected.contains(skill.id),
                  onSelected: (v) => onChanged(skill.id, v),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SetupError extends StatelessWidget {
  final String message;
  const _SetupError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
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
