import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/worker_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/closeout_provider.dart';
import '../../providers/skills_provider.dart';
import '../../providers/street_mode_provider.dart';
import '../../providers/theme_mode_provider.dart';
import '../../widgets/notification_bell.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    if (auth is! AuthSignedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final l10n = AppLocalizations.of(context);
    final user = auth.user;
    final isWorker = user.roles.isWorker;
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: const [NotificationBell()],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child: CircleAvatar(
              radius: 36,
              child: Text(
                (user.name?.isNotEmpty ?? false)
                    ? user.name![0]
                    : user.phone[0],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user.name?.isNotEmpty == true ? user.name! : user.phone,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Center(child: Text(user.phone)),
          const SizedBox(height: 24),
          if (!isWorker)
            ListTile(
              leading: const Icon(Icons.handyman_outlined),
              title: Text(l10n.profileActivateWorker),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/worker-setup?returnTo=/profile'),
            )
          else ...[
            ListTile(
              leading: Icon(
                Icons.verified_user,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.profileWorkerActive),
            ),
            _WorkerTrustPanel(userId: user.id),
            const _WorkerAvailabilityPanel(),
          ],
          const Divider(),
          _SectionHeader(title: l10n.profilePreferencesTitle),
          _PreferenceTile(
            icon: Icons.palette_outlined,
            title: l10n.themeTitle,
            subtitle: _themeTitle(l10n, themeMode),
            accent: _themeAccent(context, themeMode),
            onTap: () => _showThemeDialog(context, ref, themeMode),
          ),
          _PreferenceTile(
            icon: Icons.translate_outlined,
            title: l10n.languageTitle,
            subtitle: _languageTitle(l10n, locale.languageCode),
            accent: Theme.of(context).colorScheme.tertiaryContainer,
            onTap: () => _showLanguageDialog(context, ref, locale.languageCode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.profileSignOut),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _WorkerAvailabilityPanel extends ConsumerWidget {
  const _WorkerAvailabilityPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(workerProfileProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        child: profile.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          ),
          error: (_, __) => ListTile(
            leading: const Icon(Icons.directions_walk),
            title: Text(l10n.profileStreetModeTitle),
            subtitle: Text(l10n.profileStreetModeSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/street-mode'),
          ),
          data: (profile) => ListTile(
            leading: Icon(
              profile?.availableNow == true
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: profile?.availableNow == true
                  ? scheme.primary
                  : scheme.outline,
            ),
            title: Text(profile?.availableNow == true
                ? l10n.profileAvailabilityOnTitle
                : l10n.profileAvailabilityOffTitle),
            subtitle: Text(_availabilitySubtitle(l10n, profile)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/street-mode'),
          ),
        ),
      ),
    );
  }

  String _availabilitySubtitle(AppLocalizations l10n, WorkerProfile? profile) {
    if (profile == null) return l10n.profileStreetModeSubtitle;
    final radius = (profile.availableRadiusM / 1000).toStringAsFixed(1);
    if (profile.lastLocationAt == null) {
      return l10n.profileAvailabilityNoLocation(radius);
    }
    return l10n.profileAvailabilitySummary(radius);
  }
}

class _WorkerTrustPanel extends ConsumerWidget {
  final String userId;
  const _WorkerTrustPanel({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final trust = ref.watch(trustScoreProvider(userId));
    final skills = ref.watch(mySkillsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.profileTrustTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              trust.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.profileTrustUnavailable),
                data: (score) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricChip(
                      icon: Icons.star_outline,
                      label: l10n
                          .profileTrustScore(score.score.toStringAsFixed(0)),
                    ),
                    _MetricChip(
                      icon: Icons.reviews_outlined,
                      label: l10n.profileTrustRatings(score.ratingCount),
                    ),
                    _MetricChip(
                      icon: Icons.task_alt,
                      label: l10n.profileTrustCompleted(score.completedJobs),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.profileWorkerSkillsTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              skills.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.profileWorkerSkillsUnavailable),
                data: (items) => items.isEmpty
                    ? Text(l10n.profileWorkerNoSkills)
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in items.take(8))
                            Chip(label: Text(item.skill.name)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetricChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

Future<void> _showThemeDialog(
  BuildContext context,
  WidgetRef ref,
  ThemeMode current,
) async {
  final l10n = AppLocalizations.of(context);
  final selected = await _showPreferenceDialog<ThemeMode>(
    context: context,
    title: l10n.themeDialogTitle,
    subtitle: l10n.themeDialogSubtitle,
    selectedValue: current,
    options: [
      _PreferenceOption(
        value: ThemeMode.system,
        icon: Icons.brightness_auto_outlined,
        title: l10n.themeSystemTitle,
        description: l10n.themeSystemDescription,
      ),
      _PreferenceOption(
        value: ThemeMode.light,
        icon: Icons.light_mode_outlined,
        title: l10n.themeLightTitle,
        description: l10n.themeLightDescription,
      ),
      _PreferenceOption(
        value: ThemeMode.dark,
        icon: Icons.dark_mode_outlined,
        title: l10n.themeDarkTitle,
        description: l10n.themeDarkDescription,
      ),
    ],
  );
  if (selected != null) {
    await ref.read(themeModeControllerProvider.notifier).setMode(selected);
  }
}

Future<void> _showLanguageDialog(
  BuildContext context,
  WidgetRef ref,
  String currentLanguageCode,
) async {
  final l10n = AppLocalizations.of(context);
  final selected = await _showPreferenceDialog<String>(
    context: context,
    title: l10n.languageDialogTitle,
    subtitle: l10n.languageDialogSubtitle,
    selectedValue: currentLanguageCode,
    options: [
      _PreferenceOption(
        value: 'uz',
        icon: Icons.location_city_outlined,
        title: l10n.languageUzbekTitle,
        description: l10n.languageUzbekDescription,
      ),
      _PreferenceOption(
        value: 'ru',
        icon: Icons.forum_outlined,
        title: l10n.languageRussianTitle,
        description: l10n.languageRussianDescription,
      ),
      _PreferenceOption(
        value: 'en',
        icon: Icons.public_outlined,
        title: l10n.languageEnglishTitle,
        description: l10n.languageEnglishDescription,
      ),
    ],
  );
  if (selected != null) {
    await ref
        .read(localeControllerProvider.notifier)
        .setLocale(Locale(selected));
  }
}

String _themeTitle(AppLocalizations l10n, ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return l10n.themeSystemTitle;
    case ThemeMode.light:
      return l10n.themeLightTitle;
    case ThemeMode.dark:
      return l10n.themeDarkTitle;
  }
}

String _languageTitle(AppLocalizations l10n, String languageCode) {
  switch (languageCode) {
    case 'ru':
      return l10n.languageRussianTitle;
    case 'en':
      return l10n.languageEnglishTitle;
    case 'uz':
    default:
      return l10n.languageUzbekTitle;
  }
}

Color _themeAccent(BuildContext context, ThemeMode mode) {
  final scheme = Theme.of(context).colorScheme;
  switch (mode) {
    case ThemeMode.system:
      return scheme.secondaryContainer;
    case ThemeMode.light:
      return scheme.primaryContainer;
    case ThemeMode.dark:
      return scheme.inversePrimary;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: accent,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _PreferenceOption<T> {
  final T value;
  final IconData icon;
  final String title;
  final String description;

  const _PreferenceOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.description,
  });
}

Future<T?> _showPreferenceDialog<T>({
  required BuildContext context,
  required String title,
  required String subtitle,
  required T selectedValue,
  required List<_PreferenceOption<T>> options,
}) {
  return showDialog<T>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      final scheme = theme.colorScheme;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              for (final option in options) ...[
                _PreferenceOptionTile<T>(
                  option: option,
                  selected: option.value == selectedValue,
                  onTap: () => Navigator.of(dialogContext).pop(option.value),
                ),
                if (option != options.last) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _PreferenceOptionTile<T> extends StatelessWidget {
  final _PreferenceOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  const _PreferenceOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = selected
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final foreground = selected ? scheme.onPrimaryContainer : scheme.onSurface;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: selected ? scheme.primary : scheme.surface,
                foregroundColor: selected ? scheme.onPrimary : scheme.primary,
                child: Icon(option.icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: foreground.withValues(alpha: 0.76),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: selected ? 1 : 0.78,
                duration: const Duration(milliseconds: 160),
                child: Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? scheme.primary : scheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
