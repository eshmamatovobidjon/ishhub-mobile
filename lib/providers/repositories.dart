import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/assignments_repository.dart';
import '../data/chat_repository.dart';
import '../data/drafts_repository.dart';
import '../data/jobs_repository.dart';
import '../data/offers_repository.dart';
import '../data/profile_repository.dart';
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

final mediaUploadServiceProvider = Provider<MediaUploadService>(
  (ref) => MediaUploadService(ref.watch(apiClientProvider)),
);

final locationServiceProvider = Provider<LocationService>(
  (_) => LocationService(),
);
