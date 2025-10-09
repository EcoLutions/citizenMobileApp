import 'package:citizen_mobile_app/features/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications();
}