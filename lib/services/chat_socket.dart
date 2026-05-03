import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../config/constants.dart';
import 'storage_service.dart';

/// Thin wrapper around `WebSocketChannel` with auto-reconnect (exponential
/// backoff capped at 30s). One instance per thread.
///
/// Server contract:
///   ws://host/ws/threads/<thread_id>/?token=<JWT>
///   client → server : {"type":"typing"}
///   server → client : {"type":"connected", "thread_id": "..."}
///                     {"type":"message", "data": {<MessageSerializer>}}
///                     {"type":"typing", "user_id": "..."}
class ChatSocket {
  ChatSocket({required this.threadId, required TokenStorage tokens})
      : _tokens = tokens;

  final String threadId;
  final TokenStorage _tokens;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  final _events = StreamController<Map<String, dynamic>>.broadcast();
  bool _disposed = false;
  int _attempt = 0;
  Timer? _reconnect;

  Stream<Map<String, dynamic>> get events => _events.stream;

  Future<void> connect() async {
    if (_disposed) return;
    final access = await _tokens.readAccess();
    if (access == null) return;
    final url = '${AppConstants.wsBase}/threads/$threadId/?token=$access';
    try {
      final ch = WebSocketChannel.connect(Uri.parse(url));
      _channel = ch;
      _sub = ch.stream.listen(
        _onMessage,
        onDone: _scheduleReconnect,
        onError: (_) => _scheduleReconnect(),
        cancelOnError: true,
      );
      _attempt = 0;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void sendTyping() {
    final ch = _channel;
    if (ch == null) return;
    try {
      ch.sink.add(jsonEncode({'type': 'typing'}));
    } catch (_) {/* swallow */}
  }

  void _onMessage(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String);
      if (decoded is Map<String, dynamic>) _events.add(decoded);
    } catch (_) {/* ignore malformed frames */}
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _attempt = (_attempt + 1).clamp(1, 6);
    final delay = Duration(seconds: 1 << (_attempt - 1)); // 1,2,4,8,16,30
    final capped = delay > const Duration(seconds: 30)
        ? const Duration(seconds: 30)
        : delay;
    _reconnect?.cancel();
    _reconnect = Timer(capped, connect);
  }

  Future<void> dispose() async {
    _disposed = true;
    _reconnect?.cancel();
    await _sub?.cancel();
    try {
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (_) {/* swallow */}
    await _events.close();
  }
}
