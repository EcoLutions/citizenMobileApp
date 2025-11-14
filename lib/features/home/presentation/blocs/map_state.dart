import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
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
  final List<TrashContainer> containers;
  final TrashContainer? navigateToContainerDetail;

  MapLoaded({
    required this.markers,
    required this.polylines,
    required this.truckPosition,
    required this.initialCameraPosition,
    required this.containers,
    this.navigateToContainerDetail,
  });

  MapLoaded copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? truckPosition,
    List<TrashContainer>? containers,
    TrashContainer? navigateToContainerDetail,
    bool clearNavigation = false,
  }) {
    return MapLoaded(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      truckPosition: truckPosition ?? this.truckPosition,
      initialCameraPosition: initialCameraPosition,
      containers: containers ?? this.containers,
      navigateToContainerDetail: clearNavigation ? null : navigateToContainerDetail ?? this.navigateToContainerDetail,
    );
  }

  @override
  List<Object?> get props => [markers, polylines, truckPosition, initialCameraPosition, containers, navigateToContainerDetail];
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}