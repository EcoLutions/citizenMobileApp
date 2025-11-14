abstract class MapEvent {}

class LoadMapData extends MapEvent {
  final String municipalityId;
  LoadMapData(this.municipalityId);
}

class LoadMapAtCurrentLocation extends MapEvent {}

class AnimateTruckTick extends MapEvent {}

class ContainerTapped extends MapEvent {
  final String containerId;
  ContainerTapped(this.containerId);
}

class ClearNavigation extends MapEvent {}