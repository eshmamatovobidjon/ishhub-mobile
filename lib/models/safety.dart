import 'chat.dart';

class UserBlockSummary {
  final String id;
  final String blockerId;
  final String blockedId;
  final ChatParticipant? blockedUser;
  final String reason;
  final DateTime createdAt;

  const UserBlockSummary({
    required this.id,
    required this.blockerId,
    required this.blockedId,
    required this.blockedUser,
    required this.reason,
    required this.createdAt,
  });

  factory UserBlockSummary.fromJson(Map<String, dynamic> json) =>
      UserBlockSummary(
        id: json['id'] as String,
        blockerId: json['blocker'] as String,
        blockedId: json['blocked'] as String,
        blockedUser: json['blocked_user'] is Map<String, dynamic>
            ? ChatParticipant.fromJson(
                json['blocked_user'] as Map<String, dynamic>,
              )
            : null,
        reason: json['reason'] as String? ?? '',
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

class UserReportSummary {
  final String id;
  final String reportedUserId;
  final String reason;
  final String status;
  final DateTime createdAt;

  const UserReportSummary({
    required this.id,
    required this.reportedUserId,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory UserReportSummary.fromJson(Map<String, dynamic> json) =>
      UserReportSummary(
        id: json['id'] as String,
        reportedUserId: json['reported_user'] as String,
        reason: json['reason'] as String? ?? 'other',
        status: json['status'] as String? ?? 'open',
        createdAt: _date(json['created_at']) ?? DateTime.now(),
      );
}

DateTime? _date(Object? raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
