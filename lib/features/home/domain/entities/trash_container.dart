import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ContainerLevel { low, medium, full }

class TrashContainer extends Equatable {
  final String id;
  final LatLng position;
  final double fillLevel;

  const TrashContainer({
    required this.id,
    required this.position,
    required this.fillLevel,
  });

  ContainerLevel get level {
    if (fillLevel >= 0.8) {
      return ContainerLevel.full;
    } else if (fillLevel >= 0.5) {
      return ContainerLevel.medium;
    } else {
      return ContainerLevel.low;
    }
  }

  @override
  List<Object?> get props => [id, position, fillLevel];
}