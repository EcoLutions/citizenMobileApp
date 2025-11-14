import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:citizen_mobile_app/core/constants/api_constants.dart';
import 'package:citizen_mobile_app/features/auth/data/model/sign_in_request.dart';
import 'package:citizen_mobile_app/features/auth/data/model/sign_up_request.dart';
import 'package:citizen_mobile_app/features/auth/domain/entities/auth_response.dart';
import 'package:citizen_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUp(SignUpRequest request);
  Future<AuthResponse> signIn(SignInRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<User> signUp(SignUpRequest request) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.signUpEndpoint}');
    final response = await client.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to sign up: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<AuthResponse> signIn(SignInRequest request) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.signInEndpoint}');
    final response = await client.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to sign in: ${response.statusCode} - ${response.body}');
    }
  }
}