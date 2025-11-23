import 'dart:convert';
import 'dart:developer';

import 'package:citizen_mobile_app/core/di/injection_container.dart' as di;
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/citizen/domain/repositories/citizen_repository.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_event.dart';
import 'package:citizen_mobile_app/features/citizen/presentation/blocs/citizen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitizenBloc extends Bloc<CitizenEvent, CitizenState> {
  final CitizenRepository repository;
  final SharedPreferences sharedPreferences;

  CitizenBloc({required this.repository, required this.sharedPreferences,}) : super(CitizenInitial()) {
    on<CreateCitizenRequested>(_onCreateCitizenRequested);
    on<UpdateCitizenRequested>(_onUpdateCitizenRequested);
  }

  Future<void> _onCreateCitizenRequested(
      CreateCitizenRequested event, Emitter<CitizenState> emit) async {
    emit(CitizenLoading());
    try {
      final citizen = await repository.createCitizen(
        userId: event.userId,
        districtId: event.districtId,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phoneNumber.startsWith('+') ? event.phoneNumber : '+51${event.phoneNumber}',
      );
      await sharedPreferences.setString(
          'citizen_profile', jsonEncode(citizen.toJson()));
      // Save citizen ID for reports
      final authLocalDataSource = di.sl<AuthLocalDataSource>();
      await authLocalDataSource.saveCitizenId(citizen.id);
      await authLocalDataSource.saveCitizenDistrictId(citizen.districtId);
      emit(CitizenCreated(citizen));
    } catch (e) {
      emit(CitizenError(e.toString()));
    }
  }

  Future<void> _onUpdateCitizenRequested(
      UpdateCitizenRequested event, Emitter<CitizenState> emit) async {
    emit(CitizenLoading());
    try {
      final citizen = await repository.updateCitizen(
        citizenId: event.citizenId,
        districtId: event.districtId,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phoneNumber,
      );
      await sharedPreferences.setString(
          'citizen_profile', jsonEncode(citizen.toJson()));
      emit(CitizenUpdated(citizen));
    } catch (e) {
      emit(CitizenError(e.toString()));
    }
  }
}