import 'package:equatable/equatable.dart';

class Municipality extends Equatable {
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

  const Municipality({
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