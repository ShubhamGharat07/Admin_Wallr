import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationSendSuccess extends NotificationState {
  final String message;

  const NotificationSendSuccess({this.message = 'Notification sent successfully'});

  @override
  List<Object?> get props => [message];
}

class NotificationScheduleSuccess extends NotificationState {
  final String message;

  const NotificationScheduleSuccess({
    this.message = 'Notification scheduled successfully',
  });

  @override
  List<Object?> get props => [message];
}

class NotificationDraftSaved extends NotificationState {
  final String message;

  const NotificationDraftSaved({this.message = 'Draft saved successfully'});

  @override
  List<Object?> get props => [message];
}

class NotificationHistoryLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationHistoryLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationDeleteSuccess extends NotificationState {
  final String notificationId;
  final String message;

  const NotificationDeleteSuccess(
    this.notificationId, {
    this.message = 'Notification deleted successfully',
  });

  @override
  List<Object?> get props => [notificationId, message];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
