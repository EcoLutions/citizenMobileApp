import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IncidentReport extends Equatable {
  final String type;
  final String description;
  final LatLng location;
  final List<File> photos;

  const IncidentReport({
    required this.type,
    required this.description,
    required this.location,
    this.photos = const [],
  });

  @override
  List<Object?> get props => [type, description, location, photos];
}