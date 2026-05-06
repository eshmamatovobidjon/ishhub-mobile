class Dispute {
  final String id;
  final String jobId;
  final String openedById;
  final String againstUserId;
  final String reason;
  final String description;
  final List<String> evidenceUrls;
  final String status;
  final String outcome;
  final String resolutionNote;
  final Map<String, dynamic> aiBrief;
  final DateTime? aiBriefAt;
  final String? resolvedById;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Dispute({
    required this.id,
    required this.jobId,
    required this.openedById,
    required this.againstUserId,
    required this.reason,
    required this.description,
    required this.evidenceUrls,
    required this.status,
    required this.outcome,
    required this.resolutionNote,
    required this.aiBrief,
    required this.aiBriefAt,
    required this.resolvedById,
    required this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOpen => status == DisputeStatus.open;
  bool get isResolved => status == DisputeStatus.resolved;
  bool get hasAiBrief => aiBrief.isNotEmpty;

  factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
        id: json['id'] as String,
        jobId: json['job'] as String,
        openedById: json['opened_by'] as String,
        againstUserId: json['against_user'] as String,
        reason: json['reason'] as String? ?? DisputeReason.other,
        description: json['description'] as String? ?? '',
        evidenceUrls: (json['evidence_urls'] as List?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        status: json['status'] as String? ?? DisputeStatus.open,
        outcome: json['outcome'] as String? ?? DisputeOutcome.pending,
        resolutionNote: json['resolution_note'] as String? ?? '',
        aiBrief:
            ((json['ai_brief'] as Map?) ?? const {}).cast<String, dynamic>(),
        aiBriefAt: _date(json['ai_brief_at']),
        resolvedById: json['resolved_by'] as String?,
        resolvedAt: _date(json['resolved_at']),
        createdAt: _date(json['created_at']) ?? DateTime.now(),
        updatedAt: _date(json['updated_at']),
      );
}

class DisputeReason {
  static const String notPaid = 'not_paid';
  static const String underpaid = 'underpaid';
  static const String workNotDone = 'work_not_done';
  static const String poorQuality = 'poor_quality';
  static const String noShow = 'no_show';
  static const String damagedProperty = 'damaged_property';
  static const String abusiveBehavior = 'abusive_behavior';
  static const String other = 'other';

  static const values = [
    notPaid,
    underpaid,
    workNotDone,
    poorQuality,
    noShow,
    damagedProperty,
    abusiveBehavior,
    other,
  ];
}

class DisputeStatus {
  static const String open = 'open';
  static const String aiTriaged = 'ai_triaged';
  static const String underReview = 'under_review';
  static const String resolved = 'resolved';
  static const String cancelled = 'cancelled';
}

class DisputeOutcome {
  static const String pending = 'pending';
  static const String forOpener = 'for_opener';
  static const String againstRespondent = 'against_respondent';
  static const String split = 'split';
  static const String dismissed = 'dismissed';
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
