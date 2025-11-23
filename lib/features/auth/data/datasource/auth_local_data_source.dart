import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> deleteUserId();
  Future<void> deleteCitizenProfile();
  Future<bool> hasToken();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveCitizenId(String citizenId);
  Future<String?> getCitizenId();
  Future<void> saveCitizenDistrictId(String districtId);
  Future<String?> getCitizenDistrictId();
  Future<void> deleteCitizenId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'auth_user_id';
  static const String _citizenIdKey = 'auth_citizen_id';
  static const String _citizenDistrictIdKey = 'auth_citizen_district_id';
  static const String _citizenProfileKey = 'citizen_profile';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<void> deleteUserId() async {
    await sharedPreferences.remove(_userIdKey);
  }

  @override
  Future<void> deleteCitizenProfile() async {
    await sharedPreferences.remove(_citizenProfileKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(_userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    return sharedPreferences.getString(_userIdKey);
  }

  @override
  Future<void> saveCitizenId(String citizenId) async {
    await sharedPreferences.setString(_citizenIdKey, citizenId);
  }

  @override
  Future<String?> getCitizenId() async {
    return sharedPreferences.getString(_citizenIdKey);
  }

  @override
  Future<void> saveCitizenDistrictId(String districtId) async {
    await sharedPreferences.setString(_citizenDistrictIdKey, districtId);
  }

  @override
  Future<String?> getCitizenDistrictId() async {
    return sharedPreferences.getString(_citizenDistrictIdKey);
  }

  @override
  Future<void> deleteCitizenId() async {
    await sharedPreferences.remove(_citizenIdKey);
  }
}