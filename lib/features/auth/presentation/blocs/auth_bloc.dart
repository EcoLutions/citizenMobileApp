import 'package:citizen_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:citizen_mobile_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:citizen_mobile_app/features/citizen/domain/repositories/citizen_repository.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final CitizenRepository citizenRepository;
  final OnboardingRepository onboardingRepository;
  final SharedPreferences sharedPreferences;

  AuthBloc({
    required this.repository,
    required this.citizenRepository,
    required this.onboardingRepository,
    required this.sharedPreferences,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);

    add(CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final hasToken = await repository.hasToken();
      if (hasToken) {
        final userId = await repository.getUserId();

        if (userId != null) {
          try {
            final citizen = await citizenRepository.getCitizenByUserId(userId);
            if (citizen != null) {
              await sharedPreferences.setString(
                  'citizen_profile', jsonEncode(citizen.toJson()));
              await repository.saveCitizenId(citizen.id);
              final municipalities = await onboardingRepository.getMunicipalities('');
              final municipality = municipalities.firstWhere(
                    (m) => m.id == citizen.districtId,
                orElse: () => throw Exception('La municipalidad del ciudadano no se encontró'),
              );
              await onboardingRepository.saveMunicipality(municipality);
              print('AuthBloc: Perfil y municipalidad sincronizados (en CheckAuthStatus).');
            } else {
              print('AuthBloc: No se encontró perfil (en CheckAuthStatus).');
              await repository.deleteCitizenId();
              await sharedPreferences.remove('citizen_profile');
            }
          } catch (e) {
            print('AuthBloc: Error al sincronizar perfil (en CheckAuthStatus): $e');
          }
        }

        emit(Authenticated(user: null, userId: userId));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check authentication status'));
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await repository.signIn(
        email: event.email,
        password: event.password,
      );
      try {
        final citizen = await citizenRepository.getCitizenByUserId(response.id);
        if (citizen != null) {
          await sharedPreferences.setString(
              'citizen_profile', jsonEncode(citizen.toJson()));
          // Save citizen ID for reports
          await repository.saveCitizenId(citizen.id);
          final municipalities = await onboardingRepository.getMunicipalities('');
          final municipality = municipalities.firstWhere(
                (m) => m.id == citizen.districtId,
            orElse: () => throw Exception('La municipalidad del ciudadano no se encontró'),
          );
          await onboardingRepository.saveMunicipality(municipality);
          print('AuthBloc: Perfil de ciudadano y municipalidad sincronizados desde el backend.');
        } else {
          print('AuthBloc: No se encontró perfil de ciudadano (usuario nuevo).');
        }
      } catch (e) {
        print('AuthBloc: Error al sincronizar perfil de ciudadano: $e');
      }

      emit(Authenticated(user: null, userId: response.id));
      print('Sign in successful, token stored: ${response.token}');
    } catch (e) {
      print('Sign in failed: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.signUp(
        email: event.email,
        username: event.username,
        password: event.password,
        roles: event.roles,
      );
      // After successful sign up, emit a special state to indicate citizen creation is needed
      emit(SignUpCompleted(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await repository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Failed to sign out'));
    }
  }
}