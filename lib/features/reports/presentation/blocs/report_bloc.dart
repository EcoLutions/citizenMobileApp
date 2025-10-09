import 'dart:io';
import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_event.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final IncidentRepository incidentRepository;
  final ImagePicker _imagePicker = ImagePicker();

  ReportBloc({required this.incidentRepository}) : super(const ReportState()) {
    on<ReportTypeChanged>(_onReportTypeChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<AddPhoto>(_onAddPhoto);
    on<RemovePhoto>(_onRemovePhoto);
    on<SubmitReport>(_onSubmitReport);
  }

  void _onReportTypeChanged(ReportTypeChanged event, Emitter<ReportState> emit) {
    emit(state.copyWith(type: event.type));
  }

  void _onDescriptionChanged(DescriptionChanged event, Emitter<ReportState> emit) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onAddPhoto(AddPhoto event, Emitter<ReportState> emit) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final updatedPhotos = List<File>.from(state.photos)..add(File(pickedFile.path));
      emit(state.copyWith(photos: updatedPhotos));
    }
  }

  void _onRemovePhoto(RemovePhoto event, Emitter<ReportState> emit) {
    final updatedPhotos = List<File>.from(state.photos)..remove(event.photo);
    emit(state.copyWith(photos: updatedPhotos));
  }

  Future<void> _onSubmitReport(SubmitReport event, Emitter<ReportState> emit) async {
    emit(state.copyWith(status: ReportStatus.submitting));
    try {
      final report = IncidentReport(
        type: state.type,
        description: state.description,
        location: const LatLng(-12.085, -77.02),
        photos: state.photos,
      );

      final success = await incidentRepository.submitIncident(report);

      if (success) {
        emit(state.copyWith(status: ReportStatus.success));
      } else {
        emit(state.copyWith(status: ReportStatus.error, errorMessage: "No se pudo enviar el reporte."));
      }
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.error, errorMessage: "Ocurrió un error inesperado."));
    }
  }
}