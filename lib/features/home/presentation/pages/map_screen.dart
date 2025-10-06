import 'package:citizen_mobile_app/features/home/presentation/blocs/map_bloc.dart';
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
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style.json');
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
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
            initialCameraPosition: const CameraPosition(
              target: LatLng(-12.085, -77.02),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController?.setMapStyle(_darkMapStyle);
            },
            markers: allMarkers,
            polylines: state.polylines,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}