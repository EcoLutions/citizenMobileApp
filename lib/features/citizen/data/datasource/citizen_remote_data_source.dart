import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citizen_mobile_app/core/constants/api_constants.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/citizen/data/model/create_citizen_request.dart';
import 'package:citizen_mobile_app/features/citizen/data/model/update_citizen_request.dart';
import 'package:citizen_mobile_app/features/citizen/domain/entities/citizen.dart';

abstract class CitizenRemoteDataSource {
  Future<Citizen> createCitizen(CreateCitizenRequest request);
  Future<Citizen> updateCitizen(UpdateCitizenRequest request);
  Future<Citizen?> getCitizenByUserId(String userId);
}

class CitizenRemoteDataSourceImpl implements CitizenRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  CitizenRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  @override
  Future<Citizen> createCitizen(CreateCitizenRequest request) async {
    final token = await authLocalDataSource.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.citizensEndpoint}');

    final response = await client.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Citizen.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create citizen: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<Citizen> updateCitizen(UpdateCitizenRequest request) async {
    final token = await authLocalDataSource.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.citizensEndpoint}/${request.citizenId}');

    final response = await client.put(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Citizen.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update citizen: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<Citizen?> getCitizenByUserId(String userId) async {
    final token = await authLocalDataSource.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.citizenByUserEndpoint}/$userId');

    final response = await client.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Citizen.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get citizen: ${response.statusCode} - ${response.body}');
    }
  }
}