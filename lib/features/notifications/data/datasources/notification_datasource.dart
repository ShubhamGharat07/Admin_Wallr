import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

abstract class NotificationDataSource {
  Future<void> sendNotification(NotificationModel notification);
  Future<void> scheduleNotification(NotificationModel notification);
  Future<void> saveNotificationDraft(NotificationModel notification);
  Future<List<NotificationModel>> getNotificationHistory();
  Future<void> deleteNotification(String notificationId);
  Future<NotificationModel> getNotificationById(String id);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationDataSourceImpl(this.firestore, this.auth);

  static const String _collectionName = 'notifications';

  @override
  Future<void> sendNotification(NotificationModel notification) async {
    try {
      final currentUserId = auth.currentUser?.uid ?? 'unknown_admin';
      final notificationToSend = NotificationModel(
        id: firestore.collection(_collectionName).doc().id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: null,
        sentTime: DateTime.now(),
        status: NotificationStatus.sent,
        createdBy: currentUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: notification.stats,
      );

      await firestore
          .collection(_collectionName)
          .doc(notificationToSend.id)
          .set(notificationToSend.toMap());

      AppLogger.info(
        'Notification sent successfully: ${notificationToSend.id}',
        tag: 'NotificationDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to send notification',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> scheduleNotification(NotificationModel notification) async {
    try {
      final currentUserId = auth.currentUser?.uid ?? 'unknown_admin';
      final notificationToSchedule = NotificationModel(
        id: firestore.collection(_collectionName).doc().id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: notification.scheduledTime,
        sentTime: null,
        status: NotificationStatus.scheduled,
        createdBy: currentUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: notification.stats,
      );

      await firestore
          .collection(_collectionName)
          .doc(notificationToSchedule.id)
          .set(notificationToSchedule.toMap());

      AppLogger.info(
        'Notification scheduled for ${notification.scheduledTime}',
        tag: 'NotificationDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to schedule notification',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> saveNotificationDraft(NotificationModel notification) async {
    try {
      final currentUserId = auth.currentUser?.uid ?? 'unknown_admin';
      final draft = NotificationModel(
        id: notification.id.isEmpty
            ? firestore.collection(_collectionName).doc().id
            : notification.id,
        title: notification.title,
        body: notification.body,
        imageUrl: notification.imageUrl,
        targetAudience: notification.targetAudience,
        specificUserIds: notification.specificUserIds,
        actionType: notification.actionType,
        actionPayload: notification.actionPayload,
        scheduledTime: notification.scheduledTime,
        sentTime: null,
        status: NotificationStatus.draft,
        createdBy: currentUserId,
        createdAt: notification.createdAt,
        updatedAt: DateTime.now(),
        stats: notification.stats,
      );

      await firestore
          .collection(_collectionName)
          .doc(draft.id)
          .set(draft.toMap());

      AppLogger.info(
        'Notification saved as draft: ${draft.id}',
        tag: 'NotificationDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save notification draft',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<List<NotificationModel>> getNotificationHistory() async {
    try {
      final snapshot = await firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch notification history',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await firestore.collection(_collectionName).doc(notificationId).delete();

      AppLogger.info(
        'Notification deleted: $notificationId',
        tag: 'NotificationDataSource',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete notification',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    try {
      final doc = await firestore.collection(_collectionName).doc(id).get();

      if (!doc.exists) {
        throw Exception('Notification not found');
      }

      return NotificationModel.fromMap(doc.id, doc.data()!);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch notification',
        error: e,
        stackTrace: stackTrace,
        tag: 'NotificationDataSource',
      );
      rethrow;
    }
  }
}
