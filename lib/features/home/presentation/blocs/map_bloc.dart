import 'dart:async';
import 'dart:ui' as ui;
import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:citizen_mobile_app/features/home/domain/entities/trash_container.dart';
import 'package:citizen_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_event.dart';
import 'package:citizen_mobile_app/features/home/presentation/blocs/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:citizen_mobile_app/features/onboarding/domain/repositories/onboarding_repository.dart';


class MapBloc extends Bloc<MapEvent, MapState> {
  final HomeRepository homeRepository;
  final OnboardingRepository onboardingRepository;
  Timer? _truckAnimationTimer;
  List<LatLng> _currentRoute = [];
  int _currentPointIndex = 0;
  List<TrashContainer> _containers = [];

  MapBloc({required this.homeRepository, required this.onboardingRepository}) : super(MapInitial()) {
    on<LoadMapAtCurrentLocation>(_onLoadMapAtCurrentLocation);
    on<AnimateTruckTick>(_onAnimateTruckTick);
    on<ContainerTapped>(_onContainerTapped);
    on<ClearNavigation>(_onClearNavigation);
  }

  Future<void> _onLoadMapAtCurrentLocation(
      LoadMapAtCurrentLocation event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      // Use default Lima location instead of requesting GPS permission
      final userLocation = const LatLng(-12.0464, -77.0428); // Lima, Peru

      // --- PASO 1: OBTENER MUNICIPALIDAD GUARDADA ---
      final municipality = await onboardingRepository.getSavedMunicipality();

      if (municipality == null) {
        emit(MapError("No se encontró municipalidad seleccionada."));
        return;
      }
      final String districtId = municipality.id;
      // ----------------------------------------------

      print('DEBUG: About to call getTrashContainers');
      // --- PASO 2: USAR EL ID CORRECTO ---
      final containers = await homeRepository.getTrashContainers(districtId);
      // -------------------------------------
      print('DEBUG: Got ${containers.length} containers');
      _containers = containers;
      // --- PASO 3: USAR EL ID CORRECTO TAMBIÉN AQUÍ ---
      _currentRoute = await homeRepository.getCollectionTruckRoute(districtId);
      // ---------------------------------------------

      print('DEBUG: Creating markers for ${containers.length} containers');
      final markers = await _createMarkers(containers);
      print('DEBUG: Created ${markers.length} markers');
      final polylines = _createPolylines(_currentRoute);

      emit(MapLoaded(
        markers: markers,
        polylines: polylines,
        truckPosition: _currentRoute.isNotEmpty ? _currentRoute.first : userLocation,
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
        containers: containers,
      ));

      _startTruckAnimation();
    } catch (e) {
      print('DEBUG: Exception in _onLoadMapAtCurrentLocation: $e');
      emit(MapError("No se pudo cargar los datos del mapa."));
    }
  }

  void _startTruckAnimation() {
    _truckAnimationTimer?.cancel();
    _truckAnimationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!isClosed) {
        add(AnimateTruckTick());
      }
    });
  }

  void _onAnimateTruckTick(AnimateTruckTick event, Emitter<MapState> emit) {
    if (_currentRoute.isEmpty) return;

    if (_currentPointIndex < _currentRoute.length - 1) {
      _currentPointIndex++;
    } else {
      _currentPointIndex = 0;
    }

    final currentState = state;
    if (currentState is MapLoaded) {
      emit(currentState.copyWith(truckPosition: _currentRoute[_currentPointIndex]));
    }
  }

  void _onContainerTapped(ContainerTapped event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      try {
        final container = currentState.containers.firstWhere((c) => c.id == event.containerId);
        emit(currentState.copyWith(navigateToContainerDetail: container));
      } catch (e) {
        // Opcional: manejar el error si no se encuentra el contenedor
        print("Error: Contenedor no encontrado - ${e.toString()}");
      }
    }
  }

  void _onClearNavigation(ClearNavigation event, Emitter<MapState> emit) {
    final currentState = state;
    if (currentState is MapLoaded) {
      emit(currentState.copyWith(clearNavigation: true));
    }
  }

  Set<Polyline> _createPolylines(List<LatLng> route) {
    return {
      Polyline(
        polylineId: const PolylineId('truck_route'),
        points: route,
        color: Colors.blueAccent,
        width: 5,
      ),
    };
  }

  Future<Set<Marker>> _createMarkers(List<TrashContainer> containers) async {
    final markers = <Marker>{};
    for (var container in containers) {
      final color = _getColorForLevel(container.level);
      final icon = await _getMarkerIcon(color);
      markers.add(
        Marker(
          markerId: MarkerId(container.id),
          position: container.position,
          icon: icon,
          onTap: () {
            add(ContainerTapped(container.id));
          },
        ),
      );
    }
    return markers;
  }

  Color _getColorForLevel(ContainerLevel level) {
    switch (level) {
      case ContainerLevel.low:
        return ColorPaletter.levelLow;
      case ContainerLevel.medium:
        return ColorPaletter.levelMedium;
      case ContainerLevel.full:
        return ColorPaletter.levelFull;
    }
  }

  Future<Uint8List> _getBytesFromCanvas(int width, int height, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint backgroundPaint = Paint()..color = ColorPaletter.cardDark;
    final double radius = width / 2;

    canvas.drawCircle(Offset(radius, radius), radius, backgroundPaint);

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.delete.codePoint),
      style: TextStyle(
        fontSize: 45,
        fontFamily: Icons.delete.fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(radius - textPainter.width / 2, radius - textPainter.height / 2));

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _getMarkerIcon(Color color) async {
    final Uint8List markerIcon = await _getBytesFromCanvas(80, 80, color);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  @override
  Future<void> close() {
    _truckAnimationTimer?.cancel();
    return super.close();
  }
}