import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/geo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../providers/theme_mode_provider.dart';
import '../../services/api_client.dart';
import '../../services/location_service.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _city = TextEditingController(text: 'Toshkent');
  final _district = TextEditingController();
  GeoPoint? _location;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authControllerProvider);
    if (auth is AuthSignedIn) {
      _name.text = auth.user.name ?? '';
      _city.text =
          auth.user.city?.isNotEmpty == true ? auth.user.city! : 'Toshkent';
      _district.text = auth.user.district ?? '';
      _location = auth.user.location;
    }
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

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _district.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final locale = ref.read(localeControllerProvider);
      await ref.read(authControllerProvider.notifier).updateProfile(
            name: _name.text.trim(),
            language: locale.languageCode,
            city: _city.text.trim(),
            district: _district.text.trim(),
            latitude: _location?.latitude,
            longitude: _location?.longitude,
          );
      if (mounted) context.go('/role');
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
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileSetupTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.profileSetupHeadline,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(l10n.profileSetupSubtitle),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration:
                    InputDecoration(labelText: l10n.profileSetupNameLabel),
                validator: (v) => (v == null || v.trim().length < 2)
                    ? l10n.profileSetupNameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: locale.languageCode,
                decoration: InputDecoration(labelText: l10n.languageTitle),
                items: [
                  DropdownMenuItem(
                      value: 'uz', child: Text(l10n.languageUzbekTitle)),
                  DropdownMenuItem(
                      value: 'ru', child: Text(l10n.languageRussianTitle)),
                  DropdownMenuItem(
                      value: 'en', child: Text(l10n.languageEnglishTitle)),
                ],
                onChanged: _busy
                    ? null
                    : (value) async {
                        if (value == null) return;
                        await ref
                            .read(localeControllerProvider.notifier)
                            .setLocale(Locale(value));
                      },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _city,
                textInputAction: TextInputAction.next,
                decoration:
                    InputDecoration(labelText: l10n.profileSetupCityLabel),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _district,
                textInputAction: TextInputAction.done,
                decoration:
                    InputDecoration(labelText: l10n.profileSetupDistrictLabel),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.my_location_outlined),
                  title: Text(l10n.profileSetupLocationTitle),
                  subtitle: Text(_location == null
                      ? l10n.profileSetupLocationSubtitle
                      : l10n.profileSetupLocationReady),
                  trailing: TextButton(
                    onPressed: _busy ? null : _useCurrentLocation,
                    child: Text(l10n.profileSetupUseLocation),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.profileSetupAvatarLaterTitle),
                  subtitle: Text(l10n.profileSetupAvatarLaterSubtitle),
                ),
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
                    : const Icon(Icons.arrow_forward),
                label: Text(l10n.profileSetupContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
