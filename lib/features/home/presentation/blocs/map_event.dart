abstract class MapEvent {}

class LoadMapData extends MapEvent {
  final String municipalityId;
  LoadMapData(this.municipalityId);
}

class LoadMapAtCurrentLocation extends MapEvent {}

class AnimateTruckTick extends MapEvent {}