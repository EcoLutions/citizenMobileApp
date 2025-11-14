import 'package:citizen_mobile_app/features/citizen/data/datasource/citizen_remote_data_source.dart';
import 'package:citizen_mobile_app/features/citizen/data/model/create_citizen_request.dart';
import 'package:citizen_mobile_app/features/citizen/data/model/update_citizen_request.dart';
import 'package:citizen_mobile_app/features/citizen/domain/entities/citizen.dart';
import 'package:citizen_mobile_app/features/citizen/domain/repositories/citizen_repository.dart';

class CitizenRepositoryImpl implements CitizenRepository {
  final CitizenRemoteDataSource remoteDataSource;

  CitizenRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Citizen> createCitizen({
    required String userId,
    required String districtId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final request = CreateCitizenRequest(
      userId: userId,
      districtId: districtId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
    return await remoteDataSource.createCitizen(request);
  }

  @override
  Future<Citizen> updateCitizen({
    required String citizenId,
    required String districtId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final request = UpdateCitizenRequest(
      citizenId: citizenId,
      districtId: districtId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
    );
    return await remoteDataSource.updateCitizen(request);
  }

  @override
  Future<Citizen?> getCitizenByUserId(String userId) async {
    return await remoteDataSource.getCitizenByUserId(userId);
  }
}