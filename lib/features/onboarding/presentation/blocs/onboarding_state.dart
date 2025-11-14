import 'package:citizen_mobile_app/features/onboarding/domain/entities/municipality.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {
  final Municipality municipality;
  const OnboardingCompleted(this.municipality);
}

class OnboardingRequired extends OnboardingState {}

class MunicipalitySelectionState extends OnboardingState {
  final bool isLoading;
  final List<Municipality> allMunicipalities;
  final List<Municipality> searchResults;
  final Municipality? selectedMunicipality;
  final String searchQuery;
  final String? userId;

  const MunicipalitySelectionState({
    this.isLoading = false,
    this.allMunicipalities = const [],
    this.searchResults = const [],
    this.selectedMunicipality,
    this.searchQuery = '',
    this.userId,
  });

  MunicipalitySelectionState copyWith({
    bool? isLoading,
    List<Municipality>? allMunicipalities,
    List<Municipality>? searchResults,
    Municipality? selectedMunicipality,
    String? searchQuery,
    String? userId,
    bool clearSelection = false,
  }) {
    return MunicipalitySelectionState(
      isLoading: isLoading ?? this.isLoading,
      allMunicipalities: allMunicipalities ?? this.allMunicipalities,
      searchResults: searchResults ?? this.searchResults,
      selectedMunicipality: clearSelection ? null : selectedMunicipality ?? this.selectedMunicipality,
      searchQuery: searchQuery ?? this.searchQuery,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [isLoading, allMunicipalities, searchResults, selectedMunicipality, searchQuery, userId];

}

class MunicipalityError extends OnboardingState {
  final String message;
  const MunicipalityError(this.message);
}