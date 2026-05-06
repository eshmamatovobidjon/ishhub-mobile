import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job.dart';
import 'repositories.dart';

class FeedFilters {
  final double radiusKm;
  final String? category;
  final String? query;

  const FeedFilters({
    this.radiusKm = 15,
    this.category,
    this.query,
  });

  FeedFilters copyWith({double? radiusKm, String? category, String? query}) =>
      FeedFilters(
        radiusKm: radiusKm ?? this.radiusKm,
        category: category ?? this.category,
        query: query ?? this.query,
      );
}

final feedFiltersProvider =
    StateProvider<FeedFilters>((_) => const FeedFilters());

/// Worker feed: ranked nearby jobs. Re-fetches on filter changes.
final feedProvider = FutureProvider.autoDispose<List<JobMatch>>((ref) async {
  final filters = ref.watch(feedFiltersProvider);
  final repo = ref.watch(jobsRepositoryProvider);
  return repo.workerFeed(
    radiusKm: filters.radiusKm,
    category: filters.category,
    query: filters.query,
  );
});

final jobDetailProvider =
    FutureProvider.autoDispose.family<Job, String>((ref, id) async {
  return ref.watch(jobsRepositoryProvider).jobDetail(id);
});

final myJobsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  return ref.watch(jobsRepositoryProvider).myJobs();
});

final workerAssignmentsProvider = FutureProvider.autoDispose
    .family<List<WorkerAssignment>, String>((ref, scope) async {
  return ref.watch(jobsRepositoryProvider).myAssignments(scope: scope);
});
