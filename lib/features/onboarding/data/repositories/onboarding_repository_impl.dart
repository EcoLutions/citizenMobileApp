import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SharedPreferences sharedPreferences;

  OnboardingRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getMunicipalities(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allMunicipalities = [
      'La Victoria, Lima',
      'San Isidro, Lima',
      'Miraflores, Lima',
      'Barranco, Lima',
      'Surco, Lima',
      'San Borja, Lima',
    ];

    if (query.isEmpty) {
      return allMunicipalities;
    } else {
      return allMunicipalities
          .where((m) => m.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Future<void> saveMunicipality(String municipality) async {
    await sharedPreferences.setString('selected_municipality', municipality);
  }

  @override
  Future<String?> getSavedMunicipality() async {
    return sharedPreferences.getString('selected_municipality');
  }
}