import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationHistoryList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final Function(String) onDelete;
  final Function(NotificationEntity) onTap;

  const NotificationHistoryList({
    super.key,
    required this.notifications,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No notifications yet. Create one to get started.',
            style: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _NotificationCard(
          notification: notification,
          onDelete: () => onDelete(notification.id),
          onTap: () => onTap(notification),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onDelete,
    required this.onTap,
  });

  Color _getStatusColor(NotificationStatus status) {
    return switch (status) {
      NotificationStatus.sent => AdminColors.success,
      NotificationStatus.scheduled => AdminColors.warning,
      NotificationStatus.draft => AdminColors.textSecondary,
      NotificationStatus.failed => AdminColors.error,
    };
  }

  String _getStatusLabel(NotificationStatus status) {
    return switch (status) {
      NotificationStatus.sent => 'Sent',
      NotificationStatus.scheduled => 'Scheduled',
      NotificationStatus.draft => 'Draft',
      NotificationStatus.failed => 'Failed',
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    final statusDate =
        notification.sentTime ?? notification.scheduledTime ?? notification.createdAt;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: AdminColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AdminColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AdminColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(notification.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getStatusColor(notification.status)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _getStatusLabel(notification.status),
                        style: TextStyle(
                          color: _getStatusColor(notification.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(label: 'Sent', value: notification.stats.sent.toString()),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Delivered',
                        value: notification.stats.delivered.toString(),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(label: 'Opened', value: notification.stats.opened.toString()),
                    ),
                    if (notification.stats.failed > 0)
                      Expanded(
                        child: _StatItem(
                          label: 'Failed',
                          value: notification.stats.failed.toString(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(statusDate),
                      style: const TextStyle(
                        color: AdminColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (notification.status == NotificationStatus.draft ||
                            notification.status == NotificationStatus.scheduled)
                          TextButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Delete'),
                            style: TextButton.styleFrom(
                              foregroundColor: AdminColors.error,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AdminColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AdminColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
