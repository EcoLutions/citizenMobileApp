import 'package:equatable/equatable.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/report_type.dart';

class IncidentReport extends Equatable {
  final String citizenId;
  final String districtId;
  final double latitude;
  final double longitude;
  final String? containerId;
  final ReportType reportType;
  final String description;
  final List<String> evidenceIds;

  const IncidentReport({
    required this.citizenId,
    required this.districtId,
    required this.latitude,
    required this.longitude,
    this.containerId,
    required this.reportType,
    required this.description,
    this.evidenceIds = const [],
  });

  @override
  List<Object?> get props => [
        citizenId,
        districtId,
        latitude,
        longitude,
        containerId,
        reportType,
        description,
        evidenceIds,
      ];
}