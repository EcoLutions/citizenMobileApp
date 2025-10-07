import 'package:citizen_mobile_app/features/notifications/domain/entities/notification.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<Notification> notifications;
  final PermissionStatus permissionStatus;

  NotificationLoaded(this.notifications, this.permissionStatus);

  @override
  List<Object?> get props => [notifications, permissionStatus];
}

class NotificationEmpty extends NotificationState {
  final PermissionStatus permissionStatus;
  NotificationEmpty(this.permissionStatus);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}