import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/auth/role_picker_screen.dart';
import 'screens/auth/worker_setup_screen.dart';
import 'screens/closeout/closeout_args.dart';
import 'screens/closeout/dispute_detail_screen.dart';
import 'screens/closeout/open_dispute_screen.dart';
import 'screens/closeout/rating_screen.dart';
import 'screens/closeout/record_payment_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/home/feed_tab.dart';
import 'screens/home/jobs_tab.dart';
import 'screens/home/chat_tab.dart';
import 'screens/home/profile_tab.dart';
import 'screens/jobs/create_job_screen.dart';
import 'screens/jobs/draft_review_screen.dart';
import 'screens/jobs/job_detail_screen.dart';
import 'screens/chat/chat_detail_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/street_mode/street_mode_screen.dart';
import 'widgets/splash.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onAuth = loc == '/login' || loc.startsWith('/otp');
      final onProfileSetup = loc == '/profile-setup';
      if (auth is AuthLoading) return null;
      if (auth is AuthSignedOut) {
        return onAuth ? null : '/login';
      }
      if (auth is AuthSignedIn) {
        final needsProfile =
            auth.user.name == null || auth.user.name!.trim().isEmpty;
        if (needsProfile && !onProfileSetup) return '/profile-setup';
        if (onAuth || loc == '/') return '/feed';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/profile-setup',
        builder: (_, __) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (ctx, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(path: '/role', builder: (_, __) => const RolePickerScreen()),
      GoRoute(
        path: '/worker-setup',
        builder: (_, state) => WorkerSetupScreen(
          returnTo: state.uri.queryParameters['returnTo'],
        ),
      ),
      GoRoute(
        path: '/jobs/new',
        builder: (_, __) => const CreateJobScreen(),
      ),
      GoRoute(
        path: '/jobs/drafts/:id',
        builder: (_, state) =>
            DraftReviewScreen(draftId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/jobs/:id',
        builder: (_, state) =>
            JobDetailScreen(jobId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/assignments/:id/payment',
        builder: (_, state) => RecordPaymentScreen(
          args: state.extra is AssignmentCloseoutArgs
              ? state.extra as AssignmentCloseoutArgs
              : null,
        ),
      ),
      GoRoute(
        path: '/assignments/:id/rate',
        builder: (_, state) => RatingScreen(
          args: state.extra is AssignmentCloseoutArgs
              ? state.extra as AssignmentCloseoutArgs
              : null,
        ),
      ),
      GoRoute(
        path: '/jobs/:id/disputes/new',
        builder: (_, state) => OpenDisputeScreen(
          args: state.extra is AssignmentCloseoutArgs
              ? state.extra as AssignmentCloseoutArgs
              : null,
        ),
      ),
      GoRoute(
        path: '/disputes/:id',
        builder: (_, state) =>
            DisputeDetailScreen(disputeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/threads/:id',
        builder: (_, state) => ChatDetailScreen(
          threadId: state.pathParameters['id']!,
          title: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/street-mode',
        builder: (_, __) => const StreetModeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
      ShellRoute(
        builder: (ctx, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/feed', builder: (_, __) => const FeedTab()),
          GoRoute(path: '/jobs', builder: (_, __) => const JobsTab()),
          GoRoute(path: '/chat', builder: (_, __) => const ChatTab()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileTab()),
        ],
      ),
    ],
  );
});
