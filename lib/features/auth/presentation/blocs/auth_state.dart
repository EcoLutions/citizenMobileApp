import 'package:citizen_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User? user;
  final String? userId;

  Authenticated({this.user, this.userId});
}

class SignUpCompleted extends AuthState {
  final User user;

  SignUpCompleted({required this.user});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}