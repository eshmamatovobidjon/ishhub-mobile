import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/offer.dart';
import 'repositories.dart';

/// All offers tied to a job (for both client + worker sides).
final jobOffersProvider =
    FutureProvider.autoDispose.family<List<Offer>, String>((ref, jobId) async {
  return ref.watch(offersRepositoryProvider).list(jobId: jobId);
});
