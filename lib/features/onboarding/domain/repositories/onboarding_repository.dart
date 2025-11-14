import 'package:citizen_mobile_app/features/onboarding/domain/entities/municipality.dart';

abstract class OnboardingRepository {
  Future<List<Municipality>> getMunicipalities(String query);
  Future<void> saveMunicipality(Municipality municipality);
  Future<Municipality?> getSavedMunicipality();
}