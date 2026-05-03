import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_draft.dart';
import 'repositories.dart';

/// Polls a draft until status leaves processing (or 30 attempts).
class DraftPollNotifier extends StateNotifier<AsyncValue<JobDraft>> {
  DraftPollNotifier(this._ref, this.draftId) : super(const AsyncValue.loading()) {
    _start();
  }

  final Ref _ref;
  final String draftId;
  Timer? _timer;
  int _attempts = 0;

  Future<void> _start() async {
    await _refresh();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
  }

  Future<void> _refresh() async {
    _attempts++;
    try {
      final d = await _ref.read(draftsRepositoryProvider).draft(draftId);
      state = AsyncValue.data(d);
      if (!d.isProcessing || _attempts >= 30) _timer?.cancel();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      _timer?.cancel();
    }
  }

  Future<void> retry() async {
    _attempts = 0;
    state = const AsyncValue.loading();
    _timer?.cancel();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final draftPollProvider = StateNotifierProvider.autoDispose
    .family<DraftPollNotifier, AsyncValue<JobDraft>, String>(
  (ref, id) => DraftPollNotifier(ref, id),
);
