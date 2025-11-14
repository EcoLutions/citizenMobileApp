class SignUpRequest {
  final String email;
  final String username;
  final String password;
  final List<String> roles;

  const SignUpRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.roles,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'roles': roles,
    };
  }
}