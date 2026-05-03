import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat.dart';
import '../services/chat_socket.dart';
import 'auth_provider.dart';
import 'repositories.dart';

/// All threads the current user participates in.
final threadsProvider =
    FutureProvider.autoDispose<List<ChatThread>>((ref) async {
  return ref.watch(chatRepositoryProvider).threads();
});

/// Live message list for a given thread. Bootstraps via REST then merges
/// new messages from the WebSocket. Uses `keepAlive` so navigating away and
/// back in the same session keeps the buffer; releases when the room is
/// truly closed.
class ThreadMessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ThreadMessagesNotifier(this._ref, this.threadId)
      : super(const AsyncValue.loading()) {
    _bootstrap();
  }

  final Ref _ref;
  final String threadId;
  ChatSocket? _socket;
  StreamSubscription<Map<String, dynamic>>? _sub;

  Future<void> _bootstrap() async {
    try {
      final initial =
          await _ref.read(chatRepositoryProvider).messages(threadId);
      state = AsyncValue.data(initial);
      _connectSocket();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _connectSocket() {
    final tokens = _ref.read(tokenStorageProvider);
    final socket = ChatSocket(threadId: threadId, tokens: tokens);
    _socket = socket;
    socket.connect();
    _sub = socket.events.listen((evt) {
      if (evt['type'] != 'message') return;
      final raw = evt['data'];
      if (raw is! Map) return;
      final msg = ChatMessage.fromJson(raw.cast<String, dynamic>());
      _append(msg);
    });
  }

  void _append(ChatMessage msg) {
    final cur = state.value ?? const <ChatMessage>[];
    if (cur.any((m) => m.id == msg.id)) return;
    state = AsyncValue.data([...cur, msg]);
  }

  Future<void> sendText(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return;
    final msg =
        await _ref.read(chatRepositoryProvider).postText(threadId, trimmed);
    _append(msg); // WS may also broadcast — _append dedupes by id.
  }

  void sendTyping() => _socket?.sendTyping();

  Future<void> refresh() async {
    final fresh = await _ref.read(chatRepositoryProvider).messages(threadId);
    state = AsyncValue.data(fresh);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _socket?.dispose();
    super.dispose();
  }
}

final threadMessagesProvider = StateNotifierProvider.autoDispose
    .family<ThreadMessagesNotifier, AsyncValue<List<ChatMessage>>, String>(
  (ref, threadId) => ThreadMessagesNotifier(ref, threadId),
);
