import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/safety.dart';
import 'repositories.dart';

final myBlocksProvider = FutureProvider.autoDispose<List<UserBlockSummary>>(
  (ref) => ref.watch(safetyRepositoryProvider).blocks(),
);
