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


class MapBloc extends Bloc<MapEvent, MapState> {
  final HomeRepository homeRepository;
  Timer? _truckAnimationTimer;
  List<LatLng> _currentRoute = [];
  int _currentPointIndex = 0;

  MapBloc({required this.homeRepository}) : super(MapInitial()) {
    on<LoadMapAtCurrentLocation>(_onLoadMapAtCurrentLocation);
    on<AnimateTruckTick>(_onAnimateTruckTick);
  }

  Future<void> _onLoadMapAtCurrentLocation(
      LoadMapAtCurrentLocation event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final permissionStatus = await Permission.location.request();
      if (!permissionStatus.isGranted) {
        emit(MapError("El permiso de ubicación es necesario para usar el mapa."));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLocation = LatLng(position.latitude, position.longitude);

      final containers = await homeRepository.getTrashContainers("La Victoria");
      _currentRoute = await homeRepository.getCollectionTruckRoute("La Victoria");

      final markers = await _createMarkers(containers);
      final polylines = _createPolylines(_currentRoute);

      emit(MapLoaded(
        markers: markers,
        polylines: polylines,
        truckPosition: _currentRoute.isNotEmpty ? _currentRoute.first : userLocation,
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
      ));

      _startTruckAnimation();
    } catch (e) {
      emit(MapError("No se pudo obtener la ubicación o cargar los datos del mapa."));
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