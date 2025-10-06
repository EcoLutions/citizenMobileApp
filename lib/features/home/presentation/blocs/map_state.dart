import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng truckPosition;
  final CameraPosition initialCameraPosition;

  MapLoaded({
    required this.markers,
    required this.polylines,
    required this.truckPosition,
    required this.initialCameraPosition,
  });

  MapLoaded copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? truckPosition,
  }) {
    return MapLoaded(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      truckPosition: truckPosition ?? this.truckPosition,
      initialCameraPosition: initialCameraPosition,
    );
  }

  @override
  List<Object?> get props => [markers, polylines, truckPosition, initialCameraPosition];
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}