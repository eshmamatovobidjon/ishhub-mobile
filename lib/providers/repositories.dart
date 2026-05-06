import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/assignments_repository.dart';
import '../data/chat_repository.dart';
import '../data/disputes_repository.dart';
import '../data/drafts_repository.dart';
import '../data/jobs_repository.dart';
import '../data/notifications_repository.dart';
import '../data/offers_repository.dart';
import '../data/payments_repository.dart';
import '../data/profile_repository.dart';
import '../data/ratings_repository.dart';
import '../data/safety_repository.dart';
import '../data/skills_repository.dart';
import '../data/worker_search_repository.dart';
import '../services/location_service.dart';
import '../services/media_upload_service.dart';
import 'auth_provider.dart';

final jobsRepositoryProvider = Provider<JobsRepository>(
  (ref) => JobsRepository(ref.watch(apiClientProvider)),
);

final draftsRepositoryProvider = Provider<DraftsRepository>(
  (ref) => DraftsRepository(ref.watch(apiClientProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(apiClientProvider)),
);

final offersRepositoryProvider = Provider<OffersRepository>(
  (ref) => OffersRepository(ref.watch(apiClientProvider)),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(apiClientProvider)),
);

final assignmentsRepositoryProvider = Provider<AssignmentsRepository>(
  (ref) => AssignmentsRepository(ref.watch(apiClientProvider)),
);

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(apiClientProvider)),
);

final paymentsRepositoryProvider = Provider<PaymentsRepository>(
  (ref) => PaymentsRepository(ref.watch(apiClientProvider)),
);

final ratingsRepositoryProvider = Provider<RatingsRepository>(
  (ref) => RatingsRepository(ref.watch(apiClientProvider)),
);

final safetyRepositoryProvider = Provider<SafetyRepository>(
  (ref) => SafetyRepository(ref.watch(apiClientProvider)),
);

final disputesRepositoryProvider = Provider<DisputesRepository>(
  (ref) => DisputesRepository(ref.watch(apiClientProvider)),
);

final skillsRepositoryProvider = Provider<SkillsRepository>(
  (ref) => SkillsRepository(ref.watch(apiClientProvider)),
);

final workerSearchRepositoryProvider = Provider<WorkerSearchRepository>(
  (ref) => WorkerSearchRepository(ref.watch(apiClientProvider)),
);

final mediaUploadServiceProvider = Provider<MediaUploadService>(
  (ref) => MediaUploadService(ref.watch(apiClientProvider)),
);

final locationServiceProvider = Provider<LocationService>(
  (_) => LocationService(),
);
