import 'package:equatable/equatable.dart';
import 'notification_stats_entity.dart';

enum TargetAudience { allUsers, premium, free, specific }

enum NotificationStatus { draft, scheduled, sent, failed }

enum ActionType { openApp, deepLink }

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final TargetAudience targetAudience;
  final List<String> specificUserIds;
  final ActionType actionType;
  final String? actionPayload;
  final DateTime? scheduledTime;
  final DateTime? sentTime;
  final NotificationStatus status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NotificationStatsEntity stats;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.targetAudience,
    this.specificUserIds = const [],
    this.actionType = ActionType.openApp,
    this.actionPayload,
    this.scheduledTime,
    this.sentTime,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        imageUrl,
        targetAudience,
        specificUserIds,
        actionType,
        actionPayload,
        scheduledTime,
        sentTime,
        status,
        createdBy,
        createdAt,
        updatedAt,
        stats,
      ];
}
