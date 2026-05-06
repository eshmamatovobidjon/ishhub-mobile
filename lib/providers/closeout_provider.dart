import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dispute.dart';
import '../models/rating.dart';
import 'repositories.dart';

final jobDisputesProvider =
    FutureProvider.autoDispose.family<List<Dispute>, String>((ref, jobId) {
  return ref.watch(disputesRepositoryProvider).list(jobId: jobId);
});

final disputeDetailProvider =
    FutureProvider.autoDispose.family<Dispute, String>((ref, disputeId) {
  return ref.watch(disputesRepositoryProvider).detail(disputeId);
});

final userRatingsProvider =
    FutureProvider.autoDispose.family<List<Rating>, String>((ref, userId) {
  return ref.watch(ratingsRepositoryProvider).userRatings(userId);
});

final trustScoreProvider =
    FutureProvider.autoDispose.family<TrustScore, String>((ref, userId) {
  return ref.watch(ratingsRepositoryProvider).trustScore(userId);
});
