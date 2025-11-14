class User {
  final String id;
  final String email;
  final String? username;
  final String status;
  final int failedLoginAttempts;
  final DateTime? lastLoginAt;
  final DateTime? passwordChangedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> roles;

  const User({
    required this.id,
    required this.email,
    this.username,
    required this.status,
    required this.failedLoginAttempts,
    this.lastLoginAt,
    this.passwordChangedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      status: json['status'] as String,
      failedLoginAttempts: json['failedLoginAttempts'] as int,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      passwordChangedAt: json['passwordChangedAt'] != null
          ? DateTime.parse(json['passwordChangedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      roles: List<String>.from(json['roles'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'status': status,
      'failedLoginAttempts': failedLoginAttempts,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'passwordChangedAt': passwordChangedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roles': roles,
    };
  }
}