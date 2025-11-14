class UpdateCitizenRequest {
  final String citizenId;
  final String districtId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const UpdateCitizenRequest({
    required this.citizenId,
    required this.districtId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'citizenId': citizenId,
      'districtId': districtId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}