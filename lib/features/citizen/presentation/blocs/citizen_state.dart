import 'package:citizen_mobile_app/features/citizen/domain/entities/citizen.dart';

abstract class CitizenState {}

class CitizenInitial extends CitizenState {}

class CitizenLoading extends CitizenState {}

class CitizenCreated extends CitizenState {
  final Citizen citizen;

  CitizenCreated(this.citizen);
}

class CitizenUpdated extends CitizenState {
  final Citizen citizen;

  CitizenUpdated(this.citizen);
}

class CitizenError extends CitizenState {
  final String message;

  CitizenError(this.message);
}