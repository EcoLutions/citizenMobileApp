import 'package:equatable/equatable.dart';

class Citizen extends Equatable {
  final String id;
  final String userId;
  final String districtId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String membershipLevel;
  final int totalPoints;
  final int totalReportsSubmitted;
  final String lastActivityDate;
  final String createdAt;
  final String updatedAt;

  const Citizen({
    required this.id,
    required this.userId,
    required this.districtId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.membershipLevel,
    required this.totalPoints,
    required this.totalReportsSubmitted,
    required this.lastActivityDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'] as String,
      userId: json['userId'] as String,
      districtId: json['districtId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      membershipLevel: json['membershipLevel'] as String? ?? 'BRONZE',
      totalPoints: json['totalPoints'] as int? ?? 0,
      totalReportsSubmitted: json['totalReportsSubmitted'] as int? ?? 0,
      lastActivityDate: json['lastActivityDate'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'districtId': districtId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'membershipLevel': membershipLevel,
      'totalPoints': totalPoints,
      'totalReportsSubmitted': totalReportsSubmitted,
      'lastActivityDate': lastActivityDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        districtId,
        firstName,
        lastName,
        email,
        phoneNumber,
        membershipLevel,
        totalPoints,
        totalReportsSubmitted,
        lastActivityDate,
        createdAt,
        updatedAt,
      ];
}