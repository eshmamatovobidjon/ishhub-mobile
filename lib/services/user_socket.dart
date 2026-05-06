import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../config/constants.dart';
import 'storage_service.dart';

/// Per-user WebSocket. Auto-reconnects with exponential backoff (1,2,4,8,16,30s).
///
/// Server contract:
///   ws://host/ws/user/?token=<JWT>
///   server → client : {"type":"connected","user_id":"..."}
///                     {"type":"entity","kind":"offer.created","payload":{...}}
///                     {"type":"notification","data":{...}}
///                     {"type":"pong"}
///   client → server : {"type":"ping"}   (optional keepalive)
class UserSocket {
  UserSocket(this._tokens);
  final TokenStorage _tokens;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  final _events = StreamController<UserEvent>.broadcast();
  bool _disposed = false;
  bool _connected = false;
  int _attempt = 0;
  Timer? _reconnect;

  Stream<UserEvent> get events => _events.stream;
  bool get isConnected => _connected;

  Future<void> connect() async {
    if (_disposed) return;
    if (_connected) return;
    final access = await _tokens.readAccess();
    if (access == null) return;
    final url = '${AppConstants.wsBase}/user/?token=$access';
    try {
      final ch = WebSocketChannel.connect(Uri.parse(url));
      _channel = ch;
      _sub = ch.stream.listen(
        _onMessage,
        onDone: _onClosed,
        onError: (_) => _onClosed(),
        cancelOnError: true,
      );
      _connected = true;
      _attempt = 0;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String);
      if (decoded is! Map<String, dynamic>) return;
      final type = decoded['type'] as String?;
      if (type == null) return;
      _events.add(UserEvent(
        type: type,
        kind: decoded['kind'] as String?,
        payload: (decoded['payload'] as Map?)?.cast<String, dynamic>(),
        data: (decoded['data'] as Map?)?.cast<String, dynamic>(),
      ));
    } catch (_) {/* ignore malformed frames */}
  }

  void _onClosed() {
    _connected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _attempt = (_attempt + 1).clamp(1, 6);
    final raw = Duration(seconds: 1 << (_attempt - 1)); // 1,2,4,8,16,32
    final delay =
        raw > const Duration(seconds: 30) ? const Duration(seconds: 30) : raw;
    _reconnect?.cancel();
    _reconnect = Timer(delay, connect);
  }

  Future<void> disconnect() async {
    _connected = false;
    _reconnect?.cancel();
    await _sub?.cancel();
    _sub = null;
    try {
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (_) {/* swallow */}
    _channel = null;
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _events.close();
  }
}

class UserEvent {
  /// "connected" | "entity" | "notification" | "pong"
  final String type;

  /// For type=="entity": e.g. "offer.created", "offer.updated",
  /// "assignment.updated", "job.updated", "payment.updated", "dispute.updated".
  final String? kind;

  /// For type=="entity"
  final Map<String, dynamic>? payload;

  /// For type=="notification" — full NotificationSerializer JSON.
  final Map<String, dynamic>? data;

  const UserEvent({required this.type, this.kind, this.payload, this.data});
}
