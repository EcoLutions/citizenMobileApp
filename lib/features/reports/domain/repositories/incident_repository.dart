import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';

abstract class IncidentRepository {
  Future<bool> submitIncident(IncidentReport report);
}