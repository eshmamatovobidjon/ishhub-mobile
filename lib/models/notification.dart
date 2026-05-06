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
      case 'job_cancelled':
      case 'assignment_cancelled':
        return Icons.cancel_outlined;
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
  String? get deepLink => intent.destination;

  NotificationIntent get intent => NotificationIntent.fromData(
        data,
        kind: kind,
        notificationId: id,
      );
}

class NotificationIntent {
  final String kind;
  final String? notificationId;
  final String? route;
  final String? role;
  final String? source;
  final String? jobId;
  final String? threadId;
  final String? offerId;
  final String? assignmentId;
  final String? paymentId;
  final String? disputeId;
  final String? messageId;

  const NotificationIntent({
    required this.kind,
    required this.notificationId,
    required this.route,
    required this.role,
    required this.source,
    required this.jobId,
    required this.threadId,
    required this.offerId,
    required this.assignmentId,
    required this.paymentId,
    required this.disputeId,
    required this.messageId,
  });

  bool get wantsWorkerRole => role == 'worker';

  String? get destination {
    final routeHint = route ?? _defaultRouteForKind(kind);
    if ((routeHint == 'thread' || routeHint == 'chat') && threadId != null) {
      return '/threads/$threadId';
    }
    if (routeHint == 'dispute' && disputeId != null) {
      return '/disputes/$disputeId';
    }
    if (routeHint == 'feed') return '/feed';
    if (routeHint == 'jobs') return '/jobs';
    if (jobId != null) return '/jobs/$jobId';
    if (threadId != null) return '/threads/$threadId';
    if (disputeId != null) return '/disputes/$disputeId';
    return null;
  }

  factory NotificationIntent.fromData(
    Map<String, dynamic> data, {
    String? kind,
    String? notificationId,
  }) {
    return NotificationIntent(
      kind: kind ?? _string(data['kind']) ?? '',
      notificationId: notificationId ?? _string(data['notification_id']),
      route: _string(data['route']),
      role: _string(data['role']),
      source: _string(data['source']),
      jobId: _string(data['job_id']),
      threadId: _string(data['thread_id']),
      offerId: _string(data['offer_id']),
      assignmentId: _string(data['assignment_id']),
      paymentId: _string(data['payment_id']),
      disputeId: _string(data['dispute_id']),
      messageId: _string(data['message_id']),
    );
  }

  static String? _defaultRouteForKind(String kind) {
    return switch (kind) {
      'new_message' || 'ai_mediator' || 'new_offer' => 'thread',
      'job_cancelled' ||
      'assignment_cancelled' ||
      'job_assigned' ||
      'job_completed' =>
        'job',
      'dispute_opened' || 'dispute_resolved' => 'dispute',
      'job_feed_match' => 'feed',
      _ => null,
    };
  }
}

String? _string(Object? value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}
