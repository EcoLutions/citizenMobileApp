abstract class OnboardingRepository {
  Future<List<String>> getMunicipalities(String query);
  Future<void> saveMunicipality(String municipality);
  Future<String?> getSavedMunicipality();
}