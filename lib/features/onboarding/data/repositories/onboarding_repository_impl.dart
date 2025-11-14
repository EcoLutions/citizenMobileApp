import 'package:citizen_mobile_app/features/onboarding/data/datasource/onboarding_local_data_source.dart';
import 'package:citizen_mobile_app/features/onboarding/data/datasource/onboarding_remote_data_source.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/entities/municipality.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final OnboardingLocalDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<List<Municipality>> getMunicipalities(String query) async {
    try {
      // Try to get remote data first
      final districts = await remoteDataSource.getDistricts();
      print('DEBUG: Repository received ${districts.length} districts');
      final remoteMunicipalities = districts.map((district) => Municipality(
        id: district.id,
        name: district.name,
        code: district.code,
        boundaries: district.boundaries,
        operationalStatus: district.operationalStatus,
        serviceStartDate: district.serviceStartDate,
        subscriptionId: district.subscriptionId,
        maxVehicles: district.maxVehicles,
        maxDrivers: district.maxDrivers,
        maxContainers: district.maxContainers,
        primaryAdminEmail: district.primaryAdminEmail,
        createdAt: district.createdAt,
        updatedAt: district.updatedAt,
      )).toList();

      print('DEBUG: Repository converted to ${remoteMunicipalities.length} municipalities');
      for (var m in remoteMunicipalities) {
        print('DEBUG: Municipality: ${m.name}');
      }

      // Filter based on query
      if (query.isEmpty) {
        return remoteMunicipalities;
      } else {
        return remoteMunicipalities
            .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      print('DEBUG: Repository error: $e');
      // If remote fails, return empty list instead of local data
      return [];
    }
  }


  @override
  Future<void> saveMunicipality(Municipality municipality) async {
    await sharedPreferences.setString('selected_municipality_id', municipality.id);
    await sharedPreferences.setString('selected_municipality_name', municipality.name);
  }

  @override
  Future<Municipality?> getSavedMunicipality() async {
    final id = sharedPreferences.getString('selected_municipality_id');
    final name = sharedPreferences.getString('selected_municipality_name');
    if (id != null && name != null) {
      return Municipality(
        id: id,
        name: name,
        code: '',
        boundaries: '',
        operationalStatus: '',
        serviceStartDate: '',
        subscriptionId: '',
        maxVehicles: 0,
        maxDrivers: 0,
        maxContainers: 0,
        primaryAdminEmail: '',
        createdAt: '',
        updatedAt: '',
      );
    }
    return null;
  }
}