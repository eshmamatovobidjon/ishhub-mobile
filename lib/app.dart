import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/push_notifications_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/user_socket_provider.dart';
import 'router.dart';

class IshHubApp extends ConsumerWidget {
  const IshHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mount the per-user WebSocket + realtime event router. It self-manages
    // connect/disconnect based on auth state.
    ref.watch(realtimeListenerProvider);
    ref.watch(pushNotificationsProvider);
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
