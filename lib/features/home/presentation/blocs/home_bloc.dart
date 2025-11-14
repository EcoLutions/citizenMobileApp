import 'package:citizen_mobile_app/features/home/presentation/blocs/home_event.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/home_state.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final OnboardingRepository onboardingRepository;

  HomeBloc({required this.onboardingRepository}) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<Navigate>(_onNavigate);
    on<ToggleNotifications>(_onToggleNotifications);

    add(LoadHomeData());
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    final municipality = await onboardingRepository.getSavedMunicipality();
    emit(state.copyWith(municipalityName: municipality?.name ?? "Not selected"));
  }

  void _onNavigate(Navigate event, Emitter<HomeState> emit) {
    emit(state.copyWith(navIndex: event.index));
  }

  void _onToggleNotifications(ToggleNotifications event, Emitter<HomeState> emit) {
    emit(state.copyWith(showNotifications: !state.showNotifications));
  }
}