import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/logger.dart';
import '../../data/models/notification_stats_model.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(const NotificationInitial()) {
    on<SendNotificationRequested>(_onSendNotification);
    on<ScheduleNotificationRequested>(_onScheduleNotification);
    on<SaveNotificationDraftRequested>(_onSaveDraft);
    on<FetchNotificationHistoryRequested>(_onFetchHistory);
    on<DeleteNotificationRequested>(_onDeleteNotification);
  }

  Future<void> _onSendNotification(
    SendNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final notification = NotificationEntity(
        id: const Uuid().v4(),
        title: event.title,
        body: event.body,
        imageUrl: event.imageUrl,
        targetAudience: event.targetAudience,
        specificUserIds: event.specificUserIds,
        actionType: event.actionType,
        actionPayload: event.actionPayload,
        status: NotificationStatus.sent,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: const NotificationStatsModel(),
      );

      final result = await _repository.sendNotification(notification);

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to send notification: ${failure.message}',
            tag: 'NotificationBloc',
          );
          emit(NotificationError(failure.message));
        },
        (_) {
          AppLogger.info(
            'Notification sent successfully',
            tag: 'NotificationBloc',
          );
          emit(const NotificationSendSuccess());
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during send notification',
        error: err,
        stackTrace: stackTrace,
        tag: 'NotificationBloc',
      );
      emit(NotificationError(err.toString()));
    }
  }

  Future<void> _onScheduleNotification(
    ScheduleNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final notification = NotificationEntity(
        id: const Uuid().v4(),
        title: event.title,
        body: event.body,
        imageUrl: event.imageUrl,
        targetAudience: event.targetAudience,
        specificUserIds: event.specificUserIds,
        actionType: event.actionType,
        actionPayload: event.actionPayload,
        scheduledTime: event.scheduledTime,
        status: NotificationStatus.scheduled,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: const NotificationStatsModel(),
      );

      final result = await _repository.scheduleNotification(notification);

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to schedule notification: ${failure.message}',
            tag: 'NotificationBloc',
          );
          emit(NotificationError(failure.message));
        },
        (_) {
          AppLogger.info(
            'Notification scheduled successfully',
            tag: 'NotificationBloc',
          );
          emit(const NotificationScheduleSuccess());
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during schedule notification',
        error: err,
        stackTrace: stackTrace,
        tag: 'NotificationBloc',
      );
      emit(NotificationError(err.toString()));
    }
  }

  Future<void> _onSaveDraft(
    SaveNotificationDraftRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final notification = NotificationEntity(
        id: const Uuid().v4(),
        title: event.title,
        body: event.body,
        imageUrl: event.imageUrl,
        targetAudience: event.targetAudience,
        specificUserIds: event.specificUserIds,
        actionType: event.actionType,
        actionPayload: event.actionPayload,
        scheduledTime: event.scheduledTime,
        status: NotificationStatus.draft,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: const NotificationStatsModel(),
      );

      final result = await _repository.saveNotificationDraft(notification);

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to save draft: ${failure.message}',
            tag: 'NotificationBloc',
          );
          emit(NotificationError(failure.message));
        },
        (_) {
          AppLogger.info(
            'Draft saved successfully',
            tag: 'NotificationBloc',
          );
          emit(const NotificationDraftSaved());
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during save draft',
        error: err,
        stackTrace: stackTrace,
        tag: 'NotificationBloc',
      );
      emit(NotificationError(err.toString()));
    }
  }

  Future<void> _onFetchHistory(
    FetchNotificationHistoryRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final result = await _repository.getNotificationHistory();

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to fetch history: ${failure.message}',
            tag: 'NotificationBloc',
          );
          emit(NotificationError(failure.message));
        },
        (notifications) {
          AppLogger.info(
            'Fetched ${notifications.length} notifications',
            tag: 'NotificationBloc',
          );
          emit(NotificationHistoryLoaded(notifications));
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during fetch history',
        error: err,
        stackTrace: stackTrace,
        tag: 'NotificationBloc',
      );
      emit(NotificationError(err.toString()));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final result = await _repository.deleteNotification(event.notificationId);

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to delete notification: ${failure.message}',
            tag: 'NotificationBloc',
          );
          emit(NotificationError(failure.message));
        },
        (_) {
          AppLogger.info(
            'Notification deleted: ${event.notificationId}',
            tag: 'NotificationBloc',
          );
          emit(NotificationDeleteSuccess(event.notificationId));
        },
      );
    } catch (err, stackTrace) {
      AppLogger.error(
        'Exception during delete notification',
        error: err,
        stackTrace: stackTrace,
        tag: 'NotificationBloc',
      );
      emit(NotificationError(err.toString()));
    }
  }
}
