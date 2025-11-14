import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;
  final SharedPreferences sharedPreferences;

  OnboardingBloc({required this.repository, required this.sharedPreferences,}) : super(const MunicipalitySelectionState()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<LoadAllMunicipalities>(_onLoadAllMunicipalities);
    on<FilterMunicipality>(_onFilterMunicipality);
    on<SelectMunicipality>(_onSelectMunicipality);
    on<ConfirmMunicipalitySelection>(_onConfirmMunicipalitySelection);
  }

  Future<void> _onCheckOnboardingStatus(
      CheckOnboardingStatus event, Emitter<OnboardingState> emit) async {
    final municipality = await repository.getSavedMunicipality();
    final citizenProfileJson = sharedPreferences.getString('citizen_profile');
    if (municipality != null && citizenProfileJson != null) {
      emit(OnboardingCompleted(municipality));
    } else {
      emit(MunicipalitySelectionState(userId: event.userId));
    }
  }

  Future<void> _onLoadAllMunicipalities(
      LoadAllMunicipalities event, Emitter<OnboardingState> emit) async {
    final currentState = state as MunicipalitySelectionState;
    emit(currentState.copyWith(isLoading: true));
    print('DEBUG: Loading all municipalities...');

    try {
      final municipalities = await repository.getMunicipalities('');
      print('DEBUG: Loaded ${municipalities.length} municipalities');
      for (var m in municipalities) {
        print('DEBUG: Municipality: ${m.name}');
      }
      emit(currentState.copyWith(isLoading: false, allMunicipalities: municipalities, searchResults: municipalities));
    } catch (e) {
      print('DEBUG: Error loading municipalities: $e');
      // If there's an error, emit empty results
      emit(currentState.copyWith(isLoading: false, allMunicipalities: [], searchResults: []));
    }
  }

  void _onFilterMunicipality(FilterMunicipality event, Emitter<OnboardingState> emit) {
    final currentState = state as MunicipalitySelectionState;
    print('DEBUG: Filtering municipalities with query: "${event.query}"');
    print('DEBUG: Total municipalities: ${currentState.allMunicipalities.length}');
    final filteredResults = event.query.isEmpty
        ? currentState.allMunicipalities
        : currentState.allMunicipalities
            .where((m) => m.name.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
    print('DEBUG: Filtered results: ${filteredResults.length}');
    for (var m in filteredResults) {
      print('DEBUG: Filtered municipality: ${m.name}');
    }
    emit(currentState.copyWith(searchQuery: event.query, searchResults: filteredResults, clearSelection: true));
  }

  void _onSelectMunicipality(SelectMunicipality event, Emitter<OnboardingState> emit) {
    final currentState = state as MunicipalitySelectionState;
    emit(currentState.copyWith(
      selectedMunicipality: event.municipality,
      searchQuery: event.municipality.name,
      searchResults: [],
    ));
  }

  Future<void> _onConfirmMunicipalitySelection(
      ConfirmMunicipalitySelection event, Emitter<OnboardingState> emit) async {
    final currentState = state as MunicipalitySelectionState;
    if (currentState.selectedMunicipality != null) {
      await repository.saveMunicipality(currentState.selectedMunicipality!);
      // TODO: Here we should check if citizen exists, if not create one, if yes update district
      // For now, we'll just complete onboarding
      emit(OnboardingCompleted(currentState.selectedMunicipality!));
    }
  }
}