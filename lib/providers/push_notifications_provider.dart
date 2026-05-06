import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/notification.dart';
import 'auth_provider.dart';
import 'notification_navigation_provider.dart';
import 'notifications_provider.dart';
import 'repositories.dart';

final pushNotificationsProvider = Provider<void>((ref) {
  StreamSubscription<RemoteMessage>? openedSub;
  StreamSubscription<RemoteMessage>? foregroundSub;
  StreamSubscription<String>? tokenSub;

  Future<void> registerToken() async {
    final auth = ref.read(authControllerProvider);
    if (auth is! AuthSignedIn) return;
    try {
      await FirebaseMessaging.instance.requestPermission();
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await ref.read(notificationsRepositoryProvider).registerDevice(
            platform: _platformName(),
            pushToken: token,
            locale: auth.user.language ?? 'uz',
          );
      unawaited(
        Sentry.addBreadcrumb(
          Breadcrumb(
            category: 'push',
            message: 'device_registered',
            data: {'platform': _platformName()},
          ),
        ),
      );
    } catch (err) {
      debugPrint('push registration skipped: $err');
    }
  }

  void handleRemote(RemoteMessage message) {
    final intent = NotificationIntent.fromData(
      message.data.cast<String, dynamic>(),
      kind: message.data['kind'],
    );
    unawaited(
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'push',
          message: 'remote_tap',
          data: {
            'kind': intent.kind,
            'route': intent.route,
            'role': intent.role,
          },
        ),
      ),
    );
    unawaited(
      ref.read(notificationNavigationProvider).openRemoteIntent(intent),
    );
  }

  ref.listen<AuthState>(
    authControllerProvider,
    (previous, next) {
      if (next is AuthSignedIn) unawaited(registerToken());
    },
    fireImmediately: true,
  );

  try {
    openedSub = FirebaseMessaging.onMessageOpenedApp.listen(handleRemote);
    foregroundSub = FirebaseMessaging.onMessage.listen((_) {
      ref.read(notificationsControllerProvider.notifier).bootstrap();
    });
    tokenSub = FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      unawaited(registerToken());
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) handleRemote(message);
    }).catchError((err) {
      debugPrint('initial push message skipped: $err');
    });
  } catch (err) {
    debugPrint('push listener setup skipped: $err');
  }

  ref.onDispose(() {
    openedSub?.cancel();
    foregroundSub?.cancel();
    tokenSub?.cancel();
  });
});

String _platformName() {
  if (kIsWeb) return 'web';
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => 'ios',
    _ => 'android',
  };
}
