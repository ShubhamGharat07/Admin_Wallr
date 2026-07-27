import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../../../config/di/injection.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/new_notification_form.dart';
import '../widgets/notification_history_list.dart';
import '../widgets/notification_preview_modal.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = sl<NotificationBloc>();
    _notificationBloc.add(const FetchNotificationHistoryRequested());
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  void _handleSendNotification(
    String title,
    String body,
    String? imageUrl,
    TargetAudience audience,
    bool schedule,
    DateTime? scheduledTime,
  ) {
    if (schedule && scheduledTime != null) {
      _notificationBloc.add(
        ScheduleNotificationRequested(
          title: title,
          body: body,
          imageUrl: imageUrl,
          targetAudience: audience,
          scheduledTime: scheduledTime,
        ),
      );
    } else {
      _notificationBloc.add(
        SendNotificationRequested(
          title: title,
          body: body,
          imageUrl: imageUrl,
          targetAudience: audience,
        ),
      );
    }
  }

  void _handleDelete(String notificationId) {
    _notificationBloc.add(DeleteNotificationRequested(notificationId));
  }

  void _handleNotificationTap(NotificationEntity notification) {
    NotificationPreviewModal.show(
      context,
      title: notification.title,
      body: notification.body,
      imageUrl: notification.imageUrl,
      targetAudience: notification.targetAudience,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return BlocProvider.value(
      value: _notificationBloc,
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSendSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: const Text('Notification sent successfully!'),
              autoCloseDuration: const Duration(seconds: 3),
            );
            _notificationBloc.add(const FetchNotificationHistoryRequested());
          } else if (state is NotificationScheduleSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: const Text('Notification scheduled successfully!'),
              autoCloseDuration: const Duration(seconds: 3),
            );
            _notificationBloc.add(const FetchNotificationHistoryRequested());
          } else if (state is NotificationDeleteSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: const Text('Notification deleted!'),
              autoCloseDuration: const Duration(seconds: 3),
            );
            _notificationBloc.add(const FetchNotificationHistoryRequested());
          } else if (state is NotificationError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text('Error: ${state.message}'),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AdminColors.background,
          body: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: isMobile
                      ? _buildMobileLayout(context, state)
                      : _buildDesktopLayout(context, state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, NotificationState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _buildForm(),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _buildHistorySection(state),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, NotificationState state) {
    return Column(
      children: [
        _buildForm(),
        const SizedBox(height: 24),
        _buildHistorySection(state),
      ],
    );
  }

  Widget _buildForm() {
    return NewNotificationForm(
      onSend: (title, body, imageUrl, audience, schedule, scheduledTime) {
        _handleSendNotification(title, body, imageUrl, audience, schedule, scheduledTime);
      },
    );
  }

  Widget _buildHistorySection(NotificationState state) {
    if (state is NotificationHistoryLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification History',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 600,
            child: NotificationHistoryList(
              notifications: state.notifications,
              onDelete: _handleDelete,
              onTap: _handleNotificationTap,
            ),
          ),
        ],
      );
    } else if (state is NotificationLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AdminColors.gold),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification History',
          style: TextStyle(
            color: AdminColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AdminColors.surface,
            border: Border.all(color: AdminColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'No notifications yet',
              style: TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
