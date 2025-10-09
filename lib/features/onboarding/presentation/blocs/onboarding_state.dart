import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {
  final String municipality;
  const OnboardingCompleted(this.municipality);
}

class OnboardingRequired extends OnboardingState {}

class MunicipalitySelectionState extends OnboardingState {
  final bool isLoading;
  final List<String> searchResults;
  final String? selectedMunicipality;
  final String searchQuery;

  const MunicipalitySelectionState({
    this.isLoading = false,
    this.searchResults = const [],
    this.selectedMunicipality,
    this.searchQuery = '',
  });

  MunicipalitySelectionState copyWith({
    bool? isLoading,
    List<String>? searchResults,
    String? selectedMunicipality,
    String? searchQuery,
    bool clearSelection = false,
  }) {
    return MunicipalitySelectionState(
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
      selectedMunicipality: clearSelection ? null : selectedMunicipality ?? this.selectedMunicipality,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [isLoading, searchResults, selectedMunicipality, searchQuery];
}

class MunicipalityError extends OnboardingState {
  final String message;
  const MunicipalityError(this.message);
}