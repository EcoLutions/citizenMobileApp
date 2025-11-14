import 'dart:io';
import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';
import 'package:citizen_mobile_app/features/reports/data/model/evidence_resource.dart';
import 'package:citizen_mobile_app/features/reports/data/model/report_resource.dart';

abstract class IncidentRepository {
  Future<ReportResource> submitIncident(IncidentReport report);
  Future<EvidenceResource> uploadEvidence(File file, {String? description});
}