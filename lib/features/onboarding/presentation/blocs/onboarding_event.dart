abstract class OnboardingEvent {}

class CheckOnboardingStatus extends OnboardingEvent {}

class SearchMunicipality extends OnboardingEvent {
  final String query;
  SearchMunicipality(this.query);
}

class SelectMunicipality extends OnboardingEvent {
  final String municipality;
  SelectMunicipality(this.municipality);
}

class ConfirmMunicipalitySelection extends OnboardingEvent {}
