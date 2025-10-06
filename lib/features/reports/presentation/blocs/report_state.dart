import 'dart:io';
import 'package:equatable/equatable.dart';

enum ReportStatus { initial, submitting, success, error }

class ReportState extends Equatable {
  final String type;
  final String description;
  final List<File> photos;
  final ReportStatus status;
  final String? errorMessage;

  const ReportState({
    this.type = "Contenedor Lleno",
    this.description = "",
    this.photos = const [],
    this.status = ReportStatus.initial,
    this.errorMessage,
  });

  bool get isFormValid => description.isNotEmpty;

  ReportState copyWith({
    String? type,
    String? description,
    List<File>? photos,
    ReportStatus? status,
    String? errorMessage,
  }) {
    return ReportState(
      type: type ?? this.type,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [type, description, photos, status, errorMessage];
}