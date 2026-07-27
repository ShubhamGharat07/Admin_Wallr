import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> sendNotification(NotificationEntity notification) async {
    try {
      final model = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: notification.scheduledTime,
        sentTime: notification.sentTime,
        status: notification.status,
        createdBy: notification.createdBy,
        createdAt: notification.createdAt,
        updatedAt: notification.updatedAt,
        stats: notification.stats,
      );
      await dataSource.sendNotification(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleNotification(NotificationEntity notification) async {
    try {
      final model = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: notification.scheduledTime,
        sentTime: notification.sentTime,
        status: notification.status,
        createdBy: notification.createdBy,
        createdAt: notification.createdAt,
        updatedAt: notification.updatedAt,
        stats: notification.stats,
      );
      await dataSource.scheduleNotification(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveNotificationDraft(NotificationEntity notification) async {
    try {
      final model = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: notification.scheduledTime,
        sentTime: notification.sentTime,
        status: notification.status,
        createdBy: notification.createdBy,
        createdAt: notification.createdAt,
        updatedAt: notification.updatedAt,
        stats: notification.stats,
      );
      await dataSource.saveNotificationDraft(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationHistory() async {
    try {
      final models = await dataSource.getNotificationHistory();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await dataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id) async {
    try {
      final model = await dataSource.getNotificationById(id);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
