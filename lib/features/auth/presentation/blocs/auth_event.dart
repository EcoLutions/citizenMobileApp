abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final List<String> roles;

  SignUpRequested({
    required this.email,
    required this.username,
    required this.password,
    required this.roles,
  });
}

class SignOutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}