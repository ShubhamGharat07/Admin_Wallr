import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(NotificationEntity notification) async {
    return await repository.sendNotification(notification);
  }
}
