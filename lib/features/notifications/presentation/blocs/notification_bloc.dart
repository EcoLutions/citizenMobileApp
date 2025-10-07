import 'package:citizen_mobile_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_event.dart';
import 'package:citizen_mobile_app/features/notifications/presentation/blocs/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository}) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<DismissNotification>(_onDismissNotification);
    on<OpenNotificationSettings>(_onOpenNotificationSettings);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final permissionStatus = await Permission.notification.status;
      final notifications = await notificationRepository.getNotifications();

      if (notifications.isEmpty) {
        emit(NotificationEmpty(permissionStatus));
      } else {
        emit(NotificationLoaded(notifications, permissionStatus));
      }
    } catch (e) {
      emit(NotificationError("No se pudieron cargar las notificaciones."));
    }
  }

  void _onDismissNotification(DismissNotification event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedNotifications = currentState.notifications
          .where((notif) => notif.id != event.notificationId)
          .toList();

      if (updatedNotifications.isEmpty) {
        emit(NotificationEmpty(currentState.permissionStatus));
      } else {
        emit(NotificationLoaded(updatedNotifications, currentState.permissionStatus));
      }
    }
  }

  Future<void> _onOpenNotificationSettings(
      OpenNotificationSettings event, Emitter<NotificationState> emit) async {
    await openAppSettings();
  }
}