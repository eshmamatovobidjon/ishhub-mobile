import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'config/constants.dart';
import 'providers/theme_mode_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (_) {}
  final preferences = await SharedPreferences.getInstance();
  final app = ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
    ],
    child: const IshHubApp(),
  );
  if (AppConstants.sentryDsn.isEmpty) {
    runApp(app);
    return;
  }
  await SentryFlutter.init(
    (options) {
      options.dsn = AppConstants.sentryDsn;
      options.environment = AppConstants.sentryEnvironment;
      if (AppConstants.sentryRelease.isNotEmpty) {
        options.release = AppConstants.sentryRelease;
      }
      options.tracesSampleRate = AppConstants.sentryTracesSampleRate;
      options.sendDefaultPii = false;
    },
    appRunner: () => runApp(app),
  );
}
