import 'package:equatable/equatable.dart';

class NotificationStatsEntity extends Equatable {
  final int sent;
  final int delivered;
  final int opened;
  final int failed;

  const NotificationStatsEntity({
    this.sent = 0,
    this.delivered = 0,
    this.opened = 0,
    this.failed = 0,
  });

  @override
  List<Object?> get props => [sent, delivered, opened, failed];
}
