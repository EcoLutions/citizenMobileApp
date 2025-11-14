import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citizen_mobile_app/core/constants/api_constants.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/onboarding/data/model/district_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<List<DistrictModel>> getDistricts();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  OnboardingRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  @override
  Future<List<DistrictModel>> getDistricts() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.districtsEndpoint}');
    print('DEBUG: Calling API: $url');
    final token = await _getToken();
    print('DEBUG: Token: $token');
    final response = await client.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('DEBUG: API Response status: ${response.statusCode}');
    print('DEBUG: API Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      print('DEBUG: Parsed ${jsonList.length} districts from API');
      return jsonList.map((json) => DistrictModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load districts: ${response.statusCode}');
    }
  }

  Future<String?> _getToken() async {
    return await authLocalDataSource.getToken();
  }
}