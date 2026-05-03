import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/worker_profile.dart';
import 'repositories.dart';

/// Loads the current user's worker profile lazily; null when worker role inactive.
final workerProfileProvider =
    FutureProvider.autoDispose<WorkerProfile?>((ref) async {
  return ref.watch(profileRepositoryProvider).myWorkerProfile();
});

class StreetModeController extends StateNotifier<AsyncValue<WorkerProfile?>> {
  StreetModeController(this._ref) : super(const AsyncValue.loading()) {
    refresh();
  }
  final Ref _ref;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final p = await _ref.read(profileRepositoryProvider).myWorkerProfile();
      state = AsyncValue.data(p);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> set({
    required bool availableNow,
    int? radiusM,
    double? latitude,
    double? longitude,
  }) async {
    state = const AsyncValue.loading();
    try {
      final p = await _ref.read(profileRepositoryProvider).setStreetMode(
            availableNow: availableNow,
            radiusM: radiusM,
            latitude: latitude,
            longitude: longitude,
          );
      state = AsyncValue.data(p);
      // invalidate the cached profile so other consumers re-read
      _ref.invalidate(workerProfileProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final streetModeProvider = StateNotifierProvider<StreetModeController,
    AsyncValue<WorkerProfile?>>((ref) {
  return StreetModeController(ref);
});
