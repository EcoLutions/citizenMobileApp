import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citizen_mobile_app/core/constants/api_constants.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:citizen_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeRepositoryImpl implements HomeRepository {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  HomeRepositoryImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  @override
  Future<List<TrashContainer>> getTrashContainers(String municipalityId) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.containersByDistrictIdEndpoint}/$municipalityId');

      final token = await _getToken();
      print('DEBUG: Token: $token');
      print('DEBUG: Calling API: $url');

      if (token == null || token.isEmpty) {
        print('DEBUG: No token available, returning empty list');
        return [];
      }

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
        print('DEBUG: Parsed ${jsonList.length} containers from API');
        return jsonList.map((json) => TrashContainer.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print('DEBUG: API call failed with status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEBUG: Exception in getTrashContainers: $e');
      return [];
    }
  }

  @override
  Future<List<LatLng>> getCollectionTruckRoute(String municipalityId) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.routesEndpoint}/$municipalityId/active');
      print('DEBUG: Calling routes API: $url');
      final token = await _getToken();
      print('DEBUG: Token: $token');

      if (token == null || token.isEmpty) {
        print('DEBUG: No token available, returning default route');
        return _getDefaultRoute();
      }

      final response = await client.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Routes API Response status: ${response.statusCode}');
      print('DEBUG: Routes API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        print('DEBUG: Parsed ${jsonList.length} routes from API');

        // For now, return default route since we don't have route coordinates in the response
        // In a real implementation, you would parse the route coordinates from the API response
        return _getDefaultRoute();
      } else {
        print('DEBUG: Routes API call failed, returning default route');
        return _getDefaultRoute();
      }
    } catch (e) {
      print('DEBUG: Exception in getCollectionTruckRoute: $e');
      return _getDefaultRoute();
    }
  }

  List<LatLng> _getDefaultRoute() {
    return const [
      LatLng(-12.0850, -77.0200),
      LatLng(-12.0865, -77.0210),
      LatLng(-12.0870, -77.0195),
      LatLng(-12.0885, -77.0205),
      LatLng(-12.0890, -77.0190),
    ];
  }

  Future<String?> _getToken() async {
    return await authLocalDataSource.getToken();
  }
}