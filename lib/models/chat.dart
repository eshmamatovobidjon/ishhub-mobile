/// Mirrors `apps.chat.serializers.ThreadSerializer`.
class ChatThread {
  final String id;
  final String kind;
  final String? jobId;
  final String? jobTitle;
  final List<String> participantPhones;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const ChatThread({
    required this.id,
    required this.kind,
    required this.jobId,
    required this.jobTitle,
    required this.participantPhones,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) => ChatThread(
        id: json['id'] as String,
        kind: json['kind'] as String? ?? 'job',
        jobId: json['job'] as String?,
        jobTitle: json['job_title'] as String?,
        participantPhones: (json['participant_phones'] as List?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        lastMessageAt: _date(json['last_message_at']),
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

/// Mirrors `apps.chat.serializers.MessageSerializer`.
class ChatMessage {
  final String id;
  final String threadId;
  final String? senderId;
  final String senderPhone;
  final String kind; // text | voice | image | system | ai
  final String body;
  final String? mediaUrl;
  final String? transcript;
  final String? aiIntent;
  final Map<String, dynamic> aiPayload;
  final String? offerId;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.senderPhone,
    required this.kind,
    required this.body,
    required this.mediaUrl,
    required this.transcript,
    required this.aiIntent,
    required this.aiPayload,
    required this.offerId,
    required this.createdAt,
  });

  bool get isFromAi => kind == 'ai' || senderId == null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        threadId: json['thread'] as String,
        senderId: json['sender'] as String?,
        senderPhone: json['sender_phone'] as String? ?? '',
        kind: json['kind'] as String? ?? 'text',
        body: json['body'] as String? ?? '',
        mediaUrl: (json['media_url'] as String?)?.isEmpty == true
            ? null
            : json['media_url'] as String?,
        transcript: json['transcript'] as String?,
        aiIntent: json['ai_intent'] as String?,
        aiPayload: (json['ai_payload'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
        offerId: json['offer'] as String?,
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

DateTime? _date(Object? v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}
