import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/notification.dart';
import '../router.dart';
import 'auth_provider.dart';
import 'chat_provider.dart';
import 'closeout_provider.dart';
import 'feed_provider.dart';
import 'notifications_provider.dart';
import 'offer_provider.dart';
import 'repositories.dart';

final notificationNavigationProvider = Provider<NotificationNavigationService>(
  (ref) => NotificationNavigationService(ref),
);

class NotificationNavigationService {
  NotificationNavigationService(this._ref);
  final Ref _ref;

  Future<void> openNotification(
    BuildContext context,
    AppNotification notification,
  ) async {
    final router = GoRouter.of(context);
    await _ref
        .read(notificationsControllerProvider.notifier)
        .markRead(notification.id);
    await Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'notification.navigation',
        message: 'open_notification',
        data: {
          'notification_id': notification.id,
          'kind': notification.kind,
          'route': notification.intent.route,
          'role': notification.intent.role,
        },
      ),
    );
    await _open(router: router, intent: notification.intent);
  }

  Future<void> openRemoteIntent(NotificationIntent intent) async {
    final notificationId = intent.notificationId;
    if (notificationId != null) {
      try {
        await _ref
            .read(notificationsRepositoryProvider)
            .markRead(notificationId);
        await _ref.read(notificationsControllerProvider.notifier).bootstrap();
      } catch (_) {
        // Taps must still navigate if marking read races auth or network.
      }
    }
    await _open(router: _ref.read(routerProvider), intent: intent);
  }

  Future<void> _open({
    required GoRouter router,
    required NotificationIntent intent,
  }) async {
    final target = await _targetFor(intent);
    if (target == null) return;
    await Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'notification.navigation',
        message: 'navigate_intent',
        data: {
          'kind': intent.kind,
          'target': target,
          'role': intent.role,
          'route': intent.route,
        },
      ),
    );
    invalidateForNotificationIntent(_ref, intent);
    if (target == '/feed' || target == '/jobs' || target == '/chat') {
      router.go(target);
    } else {
      await router.push(target);
    }
  }

  Future<String?> _targetFor(NotificationIntent intent) async {
    final destination = intent.destination;
    if (destination == null) return null;
    if (!intent.wantsWorkerRole) return destination;

    try {
      await _ref.read(authControllerProvider.notifier).refreshUser();
    } catch (_) {
      // Continue with current auth state; router auth guards still apply.
    }
    final auth = _ref.read(authControllerProvider);
    final isWorker = auth is AuthSignedIn && auth.user.roles.isWorker;
    if (isWorker) return destination;
    return '/worker-setup?returnTo=${Uri.encodeComponent(destination)}';
  }
}

void invalidateForNotificationIntent(Ref ref, NotificationIntent intent) {
  final jobId = intent.jobId;
  final threadId = intent.threadId;
  final disputeId = intent.disputeId;

  if (threadId != null) {
    ref.invalidate(threadsProvider);
    ref.invalidate(threadMessagesProvider(threadId));
    ref.invalidate(threadContactProvider(threadId));
  }
  if (jobId != null) {
    ref.invalidate(jobDetailProvider(jobId));
    ref.invalidate(jobOffersProvider(jobId));
    ref.invalidate(jobDisputesProvider(jobId));
  }
  if (disputeId != null) {
    ref.invalidate(disputeDetailProvider(disputeId));
  }
  if (intent.wantsWorkerRole || intent.assignmentId != null) {
    ref.invalidate(feedProvider);
    ref.invalidate(workerAssignmentsProvider('active'));
    ref.invalidate(workerAssignmentsProvider('history'));
  }
  if (intent.role == 'client') {
    ref.invalidate(myJobsProvider);
  }
}
