import 'package:citizen_mobile_app/features/citizen/domain/entities/citizen.dart';

abstract class CitizenRepository {
  Future<Citizen> createCitizen({
    required String userId,
    required String districtId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  });

  Future<Citizen> updateCitizen({
    required String citizenId,
    required String districtId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  });

  Future<Citizen?> getCitizenByUserId(String userId);
}