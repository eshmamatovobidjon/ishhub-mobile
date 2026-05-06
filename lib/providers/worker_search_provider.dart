import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/geo.dart';
import '../models/nearby_worker.dart';
import 'repositories.dart';

class WorkerSearchFilters {
  final double radiusKm;
  final String? category;
  final String? query;

  const WorkerSearchFilters({
    this.radiusKm = 10,
    this.category,
    this.query,
  });

  WorkerSearchFilters copyWith({
    double? radiusKm,
    String? category,
    String? query,
    bool clearCategory = false,
    bool clearQuery = false,
  }) =>
      WorkerSearchFilters(
        radiusKm: radiusKm ?? this.radiusKm,
        category: clearCategory ? null : category ?? this.category,
        query: clearQuery ? null : query ?? this.query,
      );
}

final workerSearchFiltersProvider =
    StateProvider<WorkerSearchFilters>((_) => const WorkerSearchFilters());

final workerSearchOriginProvider = StateProvider<GeoPoint?>((_) => null);

final nearbyWorkersProvider =
    FutureProvider.autoDispose<List<NearbyWorker>>((ref) async {
  final origin = ref.watch(workerSearchOriginProvider);
  if (origin == null) return const [];
  final filters = ref.watch(workerSearchFiltersProvider);
  return ref.watch(workerSearchRepositoryProvider).nearbyWorkers(
        latitude: origin.latitude,
        longitude: origin.longitude,
        radiusKm: filters.radiusKm,
        category: filters.category,
        query: filters.query,
      );
});
