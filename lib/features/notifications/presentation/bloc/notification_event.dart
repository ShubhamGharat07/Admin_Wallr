import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class SendNotificationRequested extends NotificationEvent {
  final String title;
  final String body;
  final String? imageUrl;
  final TargetAudience targetAudience;
  final List<String> specificUserIds;
  final ActionType actionType;
  final String? actionPayload;

  const SendNotificationRequested({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.targetAudience,
    this.specificUserIds = const [],
    this.actionType = ActionType.openApp,
    this.actionPayload,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        imageUrl,
        targetAudience,
        specificUserIds,
        actionType,
        actionPayload,
      ];
}

class ScheduleNotificationRequested extends NotificationEvent {
  final String title;
  final String body;
  final String? imageUrl;
  final TargetAudience targetAudience;
  final List<String> specificUserIds;
  final ActionType actionType;
  final String? actionPayload;
  final DateTime scheduledTime;

  const ScheduleNotificationRequested({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.targetAudience,
    this.specificUserIds = const [],
    this.actionType = ActionType.openApp,
    this.actionPayload,
    required this.scheduledTime,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        imageUrl,
        targetAudience,
        specificUserIds,
        actionType,
        actionPayload,
        scheduledTime,
      ];
}

class SaveNotificationDraftRequested extends NotificationEvent {
  final String title;
  final String body;
  final String? imageUrl;
  final TargetAudience targetAudience;
  final List<String> specificUserIds;
  final ActionType actionType;
  final String? actionPayload;
  final DateTime? scheduledTime;

  const SaveNotificationDraftRequested({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.targetAudience,
    this.specificUserIds = const [],
    this.actionType = ActionType.openApp,
    this.actionPayload,
    this.scheduledTime,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        imageUrl,
        targetAudience,
        specificUserIds,
        actionType,
        actionPayload,
        scheduledTime,
      ];
}

class FetchNotificationHistoryRequested extends NotificationEvent {
  const FetchNotificationHistoryRequested();
}

class DeleteNotificationRequested extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
