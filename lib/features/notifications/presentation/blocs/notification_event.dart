abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class DismissNotification extends NotificationEvent {
  final String notificationId;
  DismissNotification(this.notificationId);
}

class OpenNotificationSettings extends NotificationEvent {}