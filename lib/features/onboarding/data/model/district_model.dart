import 'package:equatable/equatable.dart';

class DistrictModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String boundaries;
  final String operationalStatus;
  final String serviceStartDate;
  final String subscriptionId;
  final int maxVehicles;
  final int maxDrivers;
  final int maxContainers;
  final String primaryAdminEmail;
  final String createdAt;
  final String updatedAt;

  const DistrictModel({
    required this.id,
    required this.name,
    required this.code,
    required this.boundaries,
    required this.operationalStatus,
    required this.serviceStartDate,
    required this.subscriptionId,
    required this.maxVehicles,
    required this.maxDrivers,
    required this.maxContainers,
    required this.primaryAdminEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      boundaries: json['boundaries']?.toString() ?? '',
      operationalStatus: json['operationalStatus'] as String,
      serviceStartDate: json['serviceStartDate']?.toString() ?? '',
      subscriptionId: json['subscriptionId']?.toString() ?? '',
      maxVehicles: json['maxVehicles'] ?? 0,
      maxDrivers: json['maxDrivers'] ?? 0,
      maxContainers: json['maxContainers'] ?? 0,
      primaryAdminEmail: json['primaryAdminEmail']?.toString() ?? '',
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'boundaries': boundaries,
      'operationalStatus': operationalStatus,
      'serviceStartDate': serviceStartDate,
      'subscriptionId': subscriptionId,
      'maxVehicles': maxVehicles,
      'maxDrivers': maxDrivers,
      'maxContainers': maxContainers,
      'primaryAdminEmail': primaryAdminEmail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        boundaries,
        operationalStatus,
        serviceStartDate,
        subscriptionId,
        maxVehicles,
        maxDrivers,
        maxContainers,
        primaryAdminEmail,
        createdAt,
        updatedAt,
      ];
}