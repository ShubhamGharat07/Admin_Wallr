import '../../domain/entities/notification_stats_entity.dart';

class NotificationStatsModel extends NotificationStatsEntity {
  const NotificationStatsModel({
    super.sent = 0,
    super.delivered = 0,
    super.opened = 0,
    super.failed = 0,
  });

  factory NotificationStatsModel.fromMap(Map<String, dynamic> map) {
    return NotificationStatsModel(
      sent: map['sent'] ?? 0,
      delivered: map['delivered'] ?? 0,
      opened: map['opened'] ?? 0,
      failed: map['failed'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'sent': sent,
        'delivered': delivered,
        'opened': opened,
        'failed': failed,
      };

  factory NotificationStatsModel.empty() {
    return const NotificationStatsModel();
  }
}
