class CreateCitizenRequest {
  final String userId;
  final String districtId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const CreateCitizenRequest({
    required this.userId,
    required this.districtId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'districtId': districtId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}