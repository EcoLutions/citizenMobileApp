import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:citizen_mobile_app/features/auth/data/model/sign_in_request.dart';
import 'package:citizen_mobile_app/features/auth/data/model/sign_up_request.dart';
import 'package:citizen_mobile_app/features/auth/domain/entities/auth_response.dart';
import 'package:citizen_mobile_app/features/auth/domain/entities/user.dart';
import 'package:citizen_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> signUp({
    required String email,
    required String username,
    required String password,
    required List<String> roles,
  }) async {
    final request = SignUpRequest(
      email: email,
      username: username,
      password: password,
      roles: roles,
    );
    return await remoteDataSource.signUp(request);
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final request = SignInRequest(
      email: email,
      password: password,
    );
    final response = await remoteDataSource.signIn(request);
    await saveToken(response.token);
    await localDataSource.saveUserId(response.id);
    return response;
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> deleteToken() async {
    await localDataSource.deleteToken();
  }

  @override
  Future<void> deleteUserId() async {
    await localDataSource.deleteUserId();
  }

  @override
  Future<void> deleteCitizenProfile() async {
    await localDataSource.deleteCitizenProfile();
  }

  @override
  Future<bool> hasToken() async {
    return await localDataSource.hasToken();
  }

  @override
  Future<String?> getUserId() async {
    return await localDataSource.getUserId();
  }

  @override
  Future<void> saveCitizenId(String citizenId) async {
    await localDataSource.saveCitizenId(citizenId);
  }

  @override
  Future<String?> getCitizenId() async {
    return await localDataSource.getCitizenId();
  }

  @override
  Future<void> saveCitizenDistrictId(String districtId) async {
    await localDataSource.saveCitizenDistrictId(districtId);
  }

  @override
  Future<String?> getCitizenDistrictId() async {
    return await localDataSource.getCitizenDistrictId();
  }

  @override
  Future<void> deleteCitizenId() async {
    await localDataSource.deleteCitizenId();
  }

  @override
  Future<void> signOut() async {
    await deleteToken();
    await localDataSource.deleteUserId();
    await localDataSource.deleteCitizenId();
    await localDataSource.deleteCitizenProfile();
  }
}