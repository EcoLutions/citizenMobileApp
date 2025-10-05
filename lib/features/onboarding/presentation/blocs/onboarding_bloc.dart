import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:citizen_mobile_app/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc({required this.repository}) : super(const MunicipalitySelectionState()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<SearchMunicipality>(_onSearchMunicipality);
    on<SelectMunicipality>(_onSelectMunicipality);
    on<ConfirmMunicipalitySelection>(_onConfirmMunicipalitySelection);
  }

  Future<void> _onCheckOnboardingStatus(
      CheckOnboardingStatus event, Emitter<OnboardingState> emit) async {
    final municipality = await repository.getSavedMunicipality();
    if (municipality != null) {
      emit(OnboardingCompleted(municipality));
    } else {
      emit(const MunicipalitySelectionState());
    }
  }

  Future<void> _onSearchMunicipality(
      SearchMunicipality event, Emitter<OnboardingState> emit) async {
    final currentState = state as MunicipalitySelectionState;
    emit(currentState.copyWith(isLoading: true, searchQuery: event.query, clearSelection: true));

    if (event.query.isEmpty) {
      emit(currentState.copyWith(isLoading: false, searchResults: [], searchQuery: ''));
      return;
    }

    try {
      final municipalities = await repository.getMunicipalities(event.query);
      emit(currentState.copyWith(isLoading: false, searchResults: municipalities, searchQuery: event.query));
    } catch (e) {
      emit(const MunicipalityError("Failed to search municipalities."));
    }
  }

  void _onSelectMunicipality(SelectMunicipality event, Emitter<OnboardingState> emit) {
    final currentState = state as MunicipalitySelectionState;
    emit(currentState.copyWith(
      selectedMunicipality: event.municipality,
      searchQuery: event.municipality,
      searchResults: [],
    ));
  }

  Future<void> _onConfirmMunicipalitySelection(
      ConfirmMunicipalitySelection event, Emitter<OnboardingState> emit) async {
    final currentState = state as MunicipalitySelectionState;
    if (currentState.selectedMunicipality != null) {
      await repository.saveMunicipality(currentState.selectedMunicipality!);
      emit(OnboardingCompleted(currentState.selectedMunicipality!));
    }
  }
}