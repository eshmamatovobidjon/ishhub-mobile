import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
import '../services/user_socket.dart';
import 'auth_provider.dart';
import 'feed_provider.dart';
import 'closeout_provider.dart';
import 'notifications_provider.dart';
import 'offer_provider.dart';

/// Singleton WebSocket. Connect on sign-in, dispose on sign-out.
final userSocketProvider = Provider<UserSocket>((ref) {
  final sock = UserSocket(ref.watch(tokenStorageProvider));
  ref.onDispose(sock.dispose);
  return sock;
});

/// Reactive subscriber: connects/disconnects when auth state flips, and
/// dispatches incoming events into the right Riverpod providers /
/// notifications state.
///
/// Mounted at app root via `ref.watch(realtimeListenerProvider)` so it
/// stays alive for the entire signed-in session.
final realtimeListenerProvider = Provider<void>((ref) {
  final sock = ref.watch(userSocketProvider);
  StreamSubscription<UserEvent>? sub;

  void wireEvents() {
    sub?.cancel();
    sub = sock.events.listen((e) => _dispatch(ref, e));
  }

  ref.listen<AuthState>(authControllerProvider, (prev, next) {
    if (next is AuthSignedIn) {
      wireEvents();
      sock.connect();
      // Fire an initial unread-count + bootstrap so the bell badge is
      // correct immediately after sign-in.
      ref.read(notificationsControllerProvider.notifier).bootstrap();
    } else {
      sub?.cancel();
      sub = null;
      sock.disconnect();
      ref.read(notificationsControllerProvider.notifier).reset();
    }
  }, fireImmediately: true);

  ref.onDispose(() => sub?.cancel());
});

void _dispatch(Ref ref, UserEvent e) {
  switch (e.type) {
    case 'notification':
      final data = e.data;
      if (data == null) return;
      try {
        ref
            .read(notificationsControllerProvider.notifier)
            .prepend(AppNotification.fromJson(data));
      } catch (err) {
        debugPrint('notification parse failed: $err');
      }
      return;

    case 'entity':
      final kind = e.kind ?? '';
      final payload = e.payload ?? const {};
      final jobId = payload['job_id'] as String?;

      if (kind.startsWith('offer.')) {
        if (jobId != null) {
          ref.invalidate(jobOffersProvider(jobId));
          ref.invalidate(jobDetailProvider(jobId));
        }
      } else if (kind.startsWith('assignment.') || kind.startsWith('job.')) {
        if (jobId != null) ref.invalidate(jobDetailProvider(jobId));
        ref.invalidate(feedProvider);
        ref.invalidate(workerAssignmentsProvider('active'));
        ref.invalidate(workerAssignmentsProvider('history'));
        ref.invalidate(myJobsProvider);
      } else if (kind.startsWith('payment.')) {
        if (jobId != null) ref.invalidate(jobDetailProvider(jobId));
        ref.invalidate(workerAssignmentsProvider('active'));
        ref.invalidate(workerAssignmentsProvider('history'));
      } else if (kind.startsWith('dispute.')) {
        if (jobId != null) ref.invalidate(jobDetailProvider(jobId));
        if (jobId != null) ref.invalidate(jobDisputesProvider(jobId));
        ref.invalidate(workerAssignmentsProvider('active'));
        ref.invalidate(workerAssignmentsProvider('history'));
        final disputeId = payload['dispute_id'] as String?;
        if (disputeId != null) ref.invalidate(disputeDetailProvider(disputeId));
      }
      return;
  }
}
