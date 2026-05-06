import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
import 'repositories.dart';

class NotificationsState {
  final List<AppNotification> items;
  final int unreadCount;
  final bool loading;
  final String? error;

  const NotificationsState({
    this.items = const [],
    this.unreadCount = 0,
    this.loading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<AppNotification>? items,
    int? unreadCount,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      NotificationsState(
        items: items ?? this.items,
        unreadCount: unreadCount ?? this.unreadCount,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this._ref) : super(const NotificationsState());
  final Ref _ref;

  Future<void> bootstrap() async {
    if (state.loading) return;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final repo = _ref.read(notificationsRepositoryProvider);
      final results = await Future.wait([
        repo.list(limit: 100),
        repo.unreadCount(),
      ]);
      final items = results[0] as List<AppNotification>;
      final unread = results[1] as int;
      state = state.copyWith(items: items, unreadCount: unread, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refresh() => bootstrap();

  /// Called from the WS listener when a new notification arrives.
  void prepend(AppNotification n) {
    if (state.items.any((x) => x.id == n.id)) return;
    state = state.copyWith(
      items: [n, ...state.items],
      unreadCount: state.unreadCount + (n.isUnread ? 1 : 0),
    );
  }

  Future<void> markRead(String id) async {
    final idx = state.items.indexWhere((x) => x.id == id);
    if (idx < 0) return;
    final wasUnread = state.items[idx].isUnread;
    if (!wasUnread) return;
    final updated = [...state.items];
    updated[idx] = updated[idx].copyWith(readAt: DateTime.now());
    state = state.copyWith(
      items: updated,
      unreadCount: (state.unreadCount - 1).clamp(0, 1 << 30),
    );
    try {
      await _ref.read(notificationsRepositoryProvider).markRead(id);
    } catch (_) {/* swallow — UI already reflects the optimistic update */}
  }

  Future<void> markAllRead() async {
    if (state.unreadCount == 0) return;
    final now = DateTime.now();
    final updated = [
      for (final n in state.items) n.isUnread ? n.copyWith(readAt: now) : n,
    ];
    state = state.copyWith(items: updated, unreadCount: 0);
    try {
      await _ref.read(notificationsRepositoryProvider).markAllRead();
    } catch (_) {/* swallow */}
  }

  void reset() {
    state = const NotificationsState();
  }
}

final notificationsControllerProvider =
    StateNotifierProvider<NotificationsController, NotificationsState>(
  (ref) => NotificationsController(ref),
);
