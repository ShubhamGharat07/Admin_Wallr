import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_stats_model.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.imageUrl,
    required super.targetAudience,
    super.specificUserIds = const [],
    super.actionType = ActionType.openApp,
    super.actionPayload,
    super.scheduledTime,
    super.sentTime,
    required super.status,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
    required super.stats,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      targetAudience: TargetAudience.values.firstWhere(
        (e) => e.name == map['targetAudience'],
        orElse: () => TargetAudience.allUsers,
      ),
      specificUserIds: List<String>.from(map['specificUserIds'] ?? []),
      actionType: ActionType.values.firstWhere(
        (e) => e.name == map['actionType'],
        orElse: () => ActionType.openApp,
      ),
      actionPayload: map['actionPayload'],
      scheduledTime: parseDateTime(map['scheduledTime']),
      sentTime: parseDateTime(map['sentTime']),
      status: NotificationStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => NotificationStatus.draft,
      ),
      createdBy: map['createdBy'] ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']) ?? DateTime.now(),
      stats: NotificationStatsModel.fromMap(map['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'imageUrl': imageUrl,
        'targetAudience': targetAudience.name,
        'specificUserIds': specificUserIds,
        'actionType': actionType.name,
        'actionPayload': actionPayload,
        'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime!) : null,
        'sentTime': sentTime != null ? Timestamp.fromDate(sentTime!) : null,
        'status': status.name,
        'createdBy': createdBy,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'stats': (stats as NotificationStatsModel).toMap(),
      };
}
