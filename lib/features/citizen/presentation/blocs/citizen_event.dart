abstract class CitizenEvent {}

class CreateCitizenRequested extends CitizenEvent {
  final String userId;
  final String districtId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  CreateCitizenRequested({
    required this.userId,
    required this.districtId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });
}

class UpdateCitizenRequested extends CitizenEvent {
  final String citizenId;
  final String districtId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  UpdateCitizenRequested({
    required this.citizenId,
    required this.districtId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });
}