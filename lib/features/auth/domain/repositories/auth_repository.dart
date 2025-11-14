import 'package:citizen_mobile_app/features/auth/domain/entities/auth_response.dart';
import 'package:citizen_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({
    required String email,
    required String username,
    required String password,
    required List<String> roles,
  });
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<String?> getUserId();
  Future<void> saveCitizenId(String citizenId);
  Future<String?> getCitizenId();
  Future<void> deleteCitizenId();
  Future<void> deleteToken();
  Future<void> deleteUserId();
  Future<void> deleteCitizenProfile();
  Future<bool> hasToken();
  Future<void> signOut();
}