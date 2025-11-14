import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:citizen_mobile_app/core/constants/api_constants.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/reports/data/model/evidence_resource.dart';
import 'package:citizen_mobile_app/features/reports/data/model/report_resource.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';

abstract class ReportsRemoteDataSource {
  Future<ReportResource> submitReport(IncidentReport report);
  Future<EvidenceResource> uploadEvidence(File file, {String? description});
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  ReportsRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<String?> _getToken() async {
    return await authLocalDataSource.getToken();
  }

  @override
  Future<ReportResource> submitReport(IncidentReport report) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}');
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token available');
    }

    final response = await client.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'citizenId': report.citizenId,
        'latitude': report.latitude.toString(),
        'longitude': report.longitude.toString(),
        'containerId': report.containerId,
        'reportType': report.reportType.apiValue,
        'description': report.description,
        'evidenceIds': report.evidenceIds,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return ReportResource.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to submit report: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<EvidenceResource> uploadEvidence(File file, {String? description}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.evidencesEndpoint}');
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token available');
    }

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(_getMimeType(file.path)),
        ),
      );

    if (description != null && description.isNotEmpty) {
      request.fields['description'] = description;
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return EvidenceResource.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to upload evidence: ${response.statusCode} - ${response.body}');
    }
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }
}