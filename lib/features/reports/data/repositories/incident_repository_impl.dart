import 'dart:io';
import 'package:citizen_mobile_app/features/reports/data/datasource/reports_remote_data_source.dart';
import 'package:citizen_mobile_app/features/reports/data/model/evidence_resource.dart';
import 'package:citizen_mobile_app/features/reports/data/model/report_resource.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final ReportsRemoteDataSource remoteDataSource;

  IncidentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ReportResource> submitIncident(IncidentReport report) async {
    return await remoteDataSource.submitReport(report);
  }

  @override
  Future<EvidenceResource> uploadEvidence(File file, {String? description}) async {
    return await remoteDataSource.uploadEvidence(file, description: description);
  }
}