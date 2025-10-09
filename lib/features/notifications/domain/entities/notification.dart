import 'package:equatable/equatable.dart';

enum NotificationType { reportStatus, collectionReminder, general }

class Notification extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final NotificationType type;
  final bool isRead;

  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.type,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, body, date, type, isRead];
}