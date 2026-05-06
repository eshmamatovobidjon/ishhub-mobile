/// Mirrors `apps.chat.serializers.ThreadSerializer`.
class ChatParticipant {
  final String id;
  final String? name;
  final String? avatarUrl;
  final String? city;
  final String? district;

  const ChatParticipant({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.city,
    required this.district,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      ChatParticipant(
        id: json['id'] as String,
        name: json['name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        city: json['city'] as String?,
        district: json['district'] as String?,
      );

  String get displayName => name?.trim().isNotEmpty == true ? name!.trim() : '';
}

class ChatThread {
  final String id;
  final String kind;
  final String? jobId;
  final String? jobTitle;
  final String? jobStatus;
  final String? jobSource;
  final String? jobCreatorId;
  final String? directWorkerId;
  final List<ChatParticipant> participants;
  final List<String> participantPhones;
  final int unreadCount;
  final bool blockedByMe;
  final bool blockedMe;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const ChatThread({
    required this.id,
    required this.kind,
    required this.jobId,
    required this.jobTitle,
    required this.jobStatus,
    required this.jobSource,
    required this.jobCreatorId,
    required this.directWorkerId,
    required this.participants,
    required this.participantPhones,
    required this.unreadCount,
    required this.blockedByMe,
    required this.blockedMe,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    final blockState = (json['block_state'] as Map?)?.cast<String, dynamic>();
    return ChatThread(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'job',
      jobId: json['job'] as String?,
      jobTitle: json['job_title'] as String?,
      jobStatus: json['job_status'] as String?,
      jobSource: json['job_source'] as String?,
      jobCreatorId: json['job_creator'] as String?,
      directWorkerId: json['direct_worker'] as String?,
      participants: (json['participants'] as List?)
              ?.map(
                (e) => ChatParticipant.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      participantPhones: (json['participant_phones'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unreadCount: json['unread_count'] as int? ?? 0,
      blockedByMe: blockState?['blocked_by_me'] as bool? ?? false,
      blockedMe: blockState?['blocked_me'] as bool? ?? false,
      lastMessageAt: _date(json['last_message_at']),
      createdAt: _date(json['created_at']) ?? DateTime.now(),
    );
  }
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
  final ChatOfferSummary? offerSummary;
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
    required this.offerSummary,
    required this.createdAt,
  });

  bool get isFromAi => kind == 'ai' || senderId == null;
  bool get isOffer => kind == 'offer' && offerSummary != null;

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
        offerSummary: json['offer_summary'] is Map<String, dynamic>
            ? ChatOfferSummary.fromJson(
                json['offer_summary'] as Map<String, dynamic>,
              )
            : null,
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

class ChatOfferSummary {
  final String id;
  final String jobId;
  final String senderId;
  final String recipientId;
  final String direction;
  final String status;
  final String pricingModel;
  final num? amount;
  final String currency;
  final DateTime? proposedStart;
  final double? durationEstimateHours;
  final String note;
  final String? parentOfferId;
  final DateTime? respondedAt;
  final DateTime createdAt;

  const ChatOfferSummary({
    required this.id,
    required this.jobId,
    required this.senderId,
    required this.recipientId,
    required this.direction,
    required this.status,
    required this.pricingModel,
    required this.amount,
    required this.currency,
    required this.proposedStart,
    required this.durationEstimateHours,
    required this.note,
    required this.parentOfferId,
    required this.respondedAt,
    required this.createdAt,
  });

  bool get isOpen => status == 'sent';
  bool get isAccepted => status == 'accepted';
  bool get isDeclined => status == 'declined';
  bool get isCountered => status == 'countered';

  factory ChatOfferSummary.fromJson(Map<String, dynamic> json) =>
      ChatOfferSummary(
        id: json['id'] as String,
        jobId: json['job'] as String,
        senderId: json['sender'] as String,
        recipientId: json['recipient'] as String,
        direction: json['direction'] as String? ?? 'client_to_worker',
        status: json['status'] as String? ?? 'sent',
        pricingModel: json['pricing_model'] as String? ?? 'fixed',
        amount: json['amount'] is String
            ? num.tryParse(json['amount'] as String)
            : json['amount'] as num?,
        currency: json['currency'] as String? ?? 'UZS',
        proposedStart: _date(json['proposed_start']),
        durationEstimateHours:
            (json['duration_estimate_hours'] as num?)?.toDouble(),
        note: json['note'] as String? ?? '',
        parentOfferId: json['parent_offer'] as String?,
        respondedAt: _date(json['responded_at']),
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

class ChatAgreementResult {
  final ChatMessage message;

  const ChatAgreementResult({required this.message});

  factory ChatAgreementResult.fromJson(Map<String, dynamic> json) =>
      ChatAgreementResult(
        message: ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      );
}

class ChatContactPerson {
  final String id;
  final String name;
  final String avatarUrl;
  final String phone;

  const ChatContactPerson({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.phone,
  });

  factory ChatContactPerson.fromJson(Map<String, dynamic> json) =>
      ChatContactPerson(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
      );

  String get displayName => name.trim().isNotEmpty ? name.trim() : phone;
}

class ChatContactSummary {
  final bool available;
  final String threadId;
  final String jobId;
  final String assignmentId;
  final ChatContactPerson counterpart;
  final String callUri;

  const ChatContactSummary({
    required this.available,
    required this.threadId,
    required this.jobId,
    required this.assignmentId,
    required this.counterpart,
    required this.callUri,
  });

  factory ChatContactSummary.fromJson(Map<String, dynamic> json) =>
      ChatContactSummary(
        available: json['available'] as bool? ?? false,
        threadId: json['thread_id'] as String,
        jobId: json['job_id'] as String,
        assignmentId: json['assignment_id'] as String,
        counterpart: ChatContactPerson.fromJson(
          json['counterpart'] as Map<String, dynamic>,
        ),
        callUri: json['call_uri'] as String? ?? '',
      );
}

DateTime? _date(Object? v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}
