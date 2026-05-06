import 'package:flutter/material.dart';

/// Mirrors `apps.notifications.serializers.NotificationSerializer`.
class AppNotification {
  final String id;
  final String kind;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool sent;
  final DateTime? readAt;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.data,
    required this.sent,
    required this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  AppNotification copyWith({DateTime? readAt}) => AppNotification(
        id: id,
        kind: kind,
        title: title,
        body: body,
        data: data,
        sent: sent,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt,
      );

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: ((json['data'] as Map?) ?? const {}).cast<String, dynamic>(),
      sent: json['sent'] as bool? ?? false,
      readAt: _date(json['read_at']),
      createdAt: _date(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _date(dynamic v) {
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  /// Material icon for this notification kind. Not exhaustive — falls back
  /// to a bell.
  IconData get icon {
    switch (kind) {
      case 'new_offer':
        return Icons.local_offer_outlined;
      case 'offer_accepted':
        return Icons.check_circle_outline;
      case 'offer_declined':
        return Icons.cancel_outlined;
      case 'new_message':
      case 'ai_mediator':
        return Icons.chat_bubble_outline;
      case 'job_assigned':
        return Icons.assignment_ind_outlined;
      case 'job_completed':
        return Icons.task_alt;
      case 'payment_recorded':
        return Icons.payments_outlined;
      case 'dispute_opened':
      case 'dispute_resolved':
        return Icons.gavel_outlined;
      case 'job_feed_match':
        return Icons.work_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  /// Optional deep-link target derived from `data`. Returns null if no route.
  String? get deepLink {
    final jobId = data['job_id'] as String?;
    final threadId = data['thread_id'] as String?;
    final disputeId = data['dispute_id'] as String?;
    if (threadId != null) return '/threads/$threadId';
    if (disputeId != null) return '/disputes/$disputeId';
    if (jobId != null) return '/jobs/$jobId';
    return null;
  }
}
