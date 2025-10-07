
import 'package:citizen_mobile_app/features/notifications/domain/entities/notification.dart';
import 'package:citizen_mobile_app/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<Notification>> getNotifications() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Notification(
        id: '1',
        title: 'Reporte Procesado',
        body: 'Tu reporte de "Contenedor Lleno" en Av. Principal ha sido recibido y está siendo procesado.',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.reportStatus,
      ),
      Notification(
        id: '2',
        title: 'Recordatorio de Recolección',
        body: 'El camión recolector pasará por tu zona en aproximadamente 15 minutos.',
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.collectionReminder,
        isRead: true,
      ),
      Notification(
        id: '3',
        title: 'Actualización del Servicio',
        body: 'El horario de recolección para los días feriados ha sido actualizado. Consulta la app para más detalles.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.general,
      ),
    ];
  }
}