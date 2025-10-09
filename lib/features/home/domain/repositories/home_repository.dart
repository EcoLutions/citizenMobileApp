import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class HomeRepository {
  Future<List<TrashContainer>> getTrashContainers(String municipalityId);
  Future<List<LatLng>> getCollectionTruckRoute(String municipalityId);
}