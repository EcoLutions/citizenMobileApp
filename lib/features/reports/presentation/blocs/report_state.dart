import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/report_type.dart';

enum ReportStatus { initial, submitting, success, error }

class ReportState extends Equatable {
  final ReportType type;
  final String description;
  final double? latitude;
  final double? longitude;
  final List<File> photos;
  final List<String> evidenceIds;
  final ReportStatus status;
  final String? errorMessage;

  const ReportState({
    this.type = ReportType.containerFull,
    this.description = "",
    this.latitude,
    this.longitude,
    this.photos = const [],
    this.evidenceIds = const [],
    this.status = ReportStatus.initial,
    this.errorMessage,
  });

  bool get isFormValid =>
      description.isNotEmpty &&
      latitude != null &&
      longitude != null;

  ReportState copyWith({
    ReportType? type,
    String? description,
    String? address,
    String? district,
    double? latitude,
    double? longitude,
    List<File>? photos,
    List<String>? evidenceIds,
    ReportStatus? status,
    String? errorMessage,
  }) {
    return ReportState(
      type: type ?? this.type,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photos: photos ?? this.photos,
      evidenceIds: evidenceIds ?? this.evidenceIds,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        type,
        description,
        latitude,
        longitude,
        photos,
        evidenceIds,
        status,
        errorMessage,
      ];
}