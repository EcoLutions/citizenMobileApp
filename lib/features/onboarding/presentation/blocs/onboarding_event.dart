import 'package:citizen_mobile_app/features/onboarding/domain/entities/municipality.dart';

abstract class OnboardingEvent {}

class CheckOnboardingStatus extends OnboardingEvent {
  final String? userId;
  CheckOnboardingStatus({this.userId});
}

class LoadAllMunicipalities extends OnboardingEvent {}

class FilterMunicipality extends OnboardingEvent {
  final String query;
  FilterMunicipality(this.query);
}

class SelectMunicipality extends OnboardingEvent {
  final Municipality municipality;
  SelectMunicipality(this.municipality);
}

class ConfirmMunicipalitySelection extends OnboardingEvent {}
