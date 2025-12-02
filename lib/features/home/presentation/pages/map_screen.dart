import 'package:citizen_mobile_app/core/navigation/screens_routes.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_bloc.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_event.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#242f3e"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#746855"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#242f3e"}]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#d59563"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#d59563"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#263c3f"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#6b9a76"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#38414e"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#212a37"}]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9ca5b3"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#746855"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#1f2835"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#f3d19c"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#17263c"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#515c6d"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#17263c"}]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    // CAMBIA DE BlocBuilder A BlocConsumer
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) { // <-- AÑADE ESTE LISTENER
        if (state is MapLoaded && state.navigateToContainerDetail != null) {
          // Navega a la pantalla de detalle
          Navigator.of(context).pushNamed(
            ScreensRoutes.containerDetail,
            arguments: state.navigateToContainerDetail,
          );
          // Limpia el trigger de navegación
          context.read<MapBloc>().add(ClearNavigation());
        }
      },
      builder: (context, state) { // <-- ESTE ES TU BUILDER EXISTENTE
        if (state is MapLoading || state is MapInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MapError) {
          return Center(child: Text(state.message));
        }

        if (state is MapLoaded) {
          final allMarkers = Set<Marker>.from(state.markers)
            ..add(
              Marker(
                markerId: const MarkerId('truck'),
                position: state.truckPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                anchor: const Offset(0.5, 0.5),
              ),
            );

          return GoogleMap(
            padding: const EdgeInsets.only(bottom: 90.0, top: 120.0),
            initialCameraPosition: state.initialCameraPosition,
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController?.setMapStyle(_darkMapStyle);
            },
            markers: allMarkers,
            polylines: state.polylines,
            onTap: (position) {
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}