import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ContainerLevel { low, medium, full }

class TrashContainer extends Equatable {
  final String id;
  final String latitude;
  final String longitude;
  final int volumeLiters;
  final int maxFillLevel;
  final String containerType;
  final String status;
  final int currentFillLevel;
  final String deviceId;
  final String lastReadingTimestamp;
  final String districtId;
  final String lastCollectionDate;
  final int collectionFrequencyDays;
  final String createdAt;
  final String updatedAt;

  const TrashContainer({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.volumeLiters,
    required this.maxFillLevel,
    required this.containerType,
    required this.status,
    required this.currentFillLevel,
    required this.deviceId,
    required this.lastReadingTimestamp,
    required this.districtId,
    required this.lastCollectionDate,
    required this.collectionFrequencyDays,
    required this.createdAt,
    required this.updatedAt,
  });

  LatLng get position => LatLng(double.parse(latitude), double.parse(longitude));

  double get fillLevel => currentFillLevel / 100.0;

  ContainerLevel get level {
    if (fillLevel >= 0.8) {
      return ContainerLevel.full;
    } else if (fillLevel >= 0.5) {
      return ContainerLevel.medium;
    } else {
      return ContainerLevel.low;
    }
  }

  factory TrashContainer.fromJson(Map<String, dynamic> json) {
    return TrashContainer(
      id: json['id'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      volumeLiters: json['volumeLiters'] as int,
      maxFillLevel: json['maxFillLevel'] as int,
      containerType: json['containerType'] as String,
      status: json['status'] as String,
      currentFillLevel: json['currentFillLevel'] as int,
      deviceId: json['deviceId'] as String? ?? '',
      lastReadingTimestamp: json['lastReadingTimestamp'] as String? ?? '',
      districtId: json['districtId'] as String? ?? '',
      lastCollectionDate: json['lastCollectionDate'] as String? ?? '',
      collectionFrequencyDays: json['collectionFrequencyDays'] as int,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        volumeLiters,
        maxFillLevel,
        containerType,
        status,
        currentFillLevel,
        deviceId,
        lastReadingTimestamp,
        districtId,
        lastCollectionDate,
        collectionFrequencyDays,
        createdAt,
        updatedAt,
      ];
}