import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> sendNotification(NotificationEntity notification);
  Future<Either<Failure, void>> scheduleNotification(NotificationEntity notification);
  Future<Either<Failure, void>> saveNotificationDraft(NotificationEntity notification);
  Future<Either<Failure, List<NotificationEntity>>> getNotificationHistory();
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id);
}
