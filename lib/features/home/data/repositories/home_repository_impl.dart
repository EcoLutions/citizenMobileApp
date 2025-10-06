import 'dart:math';

import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:citizen_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<TrashContainer>> getTrashContainers(String municipalityId) async {
    await Future.delayed(const Duration(seconds: 1));
    final random = Random();
    return List.generate(15, (index) {
      return TrashContainer(
        id: 'container_$index',
        position: LatLng(
          -12.085 + (random.nextDouble() - 0.5) * 0.02,
          -77.02 + (random.nextDouble() - 0.5) * 0.02,
        ),
        fillLevel: random.nextDouble(),
      );
    });
  }

  @override
  Future<List<LatLng>> getCollectionTruckRoute(String municipalityId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      LatLng(-12.0850, -77.0200),
      LatLng(-12.0865, -77.0210),
      LatLng(-12.0870, -77.0195),
      LatLng(-12.0885, -77.0205),
      LatLng(-12.0890, -77.0190),
    ];
  }
}