import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  @override
  Future<bool> submitIncident(IncidentReport report) async {
    print("Enviando reporte:");
    print("Tipo: ${report.type}");
    print("Descripción: ${report.description}");
    print("Ubicación: ${report.location}");
    print("Fotos: ${report.photos.length}");

    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
}