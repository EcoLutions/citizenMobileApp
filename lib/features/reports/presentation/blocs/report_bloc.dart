import 'dart:io';
import 'package:citizen_mobile_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:citizen_mobile_app/features/reports/domain/entities/incident_report.dart';
import 'package:citizen_mobile_app/features/reports/domain/repositories/incident_repository.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_event.dart';
import 'package:citizen_mobile_app/features/reports/presentation/blocs/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final IncidentRepository incidentRepository;
  final AuthLocalDataSource authLocalDataSource;
  final ImagePicker _imagePicker = ImagePicker();

  ReportBloc({
    required this.incidentRepository,
    required this.authLocalDataSource,
  }) : super(const ReportState()) {
    on<ReportTypeChanged>(_onReportTypeChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<LocationChanged>(_onLocationChanged);
    on<AddPhoto>(_onAddPhoto);
    on<RemovePhoto>(_onRemovePhoto);
    on<SubmitReport>(_onSubmitReport);
    on<ResetReportForm>(_onResetReportForm);
  }

  void _onReportTypeChanged(ReportTypeChanged event, Emitter<ReportState> emit) {
    emit(state.copyWith(type: event.type));
  }

  void _onDescriptionChanged(DescriptionChanged event, Emitter<ReportState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onLocationChanged(LocationChanged event, Emitter<ReportState> emit) {
    emit(state.copyWith(latitude: event.latitude, longitude: event.longitude));
  }

  Future<void> _onAddPhoto(AddPhoto event, Emitter<ReportState> emit) async {
    try {
      // Request permissions based on source
      PermissionStatus permissionStatus;
      if (event.source == ImageSource.camera) {
        permissionStatus = await Permission.camera.request();
      } else {
        permissionStatus = await Permission.photos.request();
      }

      if (permissionStatus.isGranted) {
        final XFile? pickedFile = await _imagePicker.pickImage(source: event.source);
        if (pickedFile != null) {
          final updatedPhotos = List<File>.from(state.photos)..add(File(pickedFile.path));
          emit(state.copyWith(photos: updatedPhotos));
        }
      } else {
        // Handle permission denied - could emit an error state or show a message
        print('Permission denied for ${event.source == ImageSource.camera ? 'camera' : 'gallery'}');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _onRemovePhoto(RemovePhoto event, Emitter<ReportState> emit) {
    final updatedPhotos = List<File>.from(state.photos)..remove(event.photo);
    emit(state.copyWith(photos: updatedPhotos));
  }

  void _onResetReportForm(ResetReportForm event, Emitter<ReportState> emit) {
    emit(const ReportState());
  }

  Future<void> _onSubmitReport(SubmitReport event, Emitter<ReportState> emit) async {
    emit(state.copyWith(status: ReportStatus.submitting));
    try {
      // Get current user ID from auth
      final userId = await _getCurrentUserId();
      if (userId == null) {
        emit(state.copyWith(
          status: ReportStatus.error,
          errorMessage: "Usuario no autenticado.",
        ));
        return;
      }
      //Get current user district ID from auth
      final districtId = await _getCurrentUserDistrictId();
      if (districtId == null) {
        emit(state.copyWith(
          status: ReportStatus.error,
          errorMessage: "Usuario no autenticado.",
        ));
        return;
      }

      // Upload evidences first
      final evidenceIds = <String>[];
      for (final photo in state.photos) {
        try {
          final evidence = await incidentRepository.uploadEvidence(photo);
          evidenceIds.add(evidence.id);
        } catch (e) {
          // Continue with other photos if one fails
          print('Failed to upload evidence: $e');
        }
      }

      // Create and submit report
      final report = IncidentReport(
        citizenId: userId,
        districtId: districtId,
        latitude: state.latitude!,
        longitude: state.longitude!,
        reportType: state.type,
        description: state.description,
        evidenceIds: evidenceIds,
      );

      final result = await incidentRepository.submitIncident(report);
      print('Report submitted successfully: ${result.id}');
      emit(state.copyWith(status: ReportStatus.success));
    } catch (e, stackTrace) {
      print('Error submitting report: $e');
      print('Stack trace: $stackTrace');
      emit(state.copyWith(
        status: ReportStatus.error,
        errorMessage: "Ocurrió un error al enviar el reporte: ${e.toString()}",
      ));
    }
  }

  Future<String?> _getCurrentUserId() async {
    // Get citizen ID from local storage
    final citizenId = await authLocalDataSource.getCitizenId();
    if (citizenId == null || citizenId.isEmpty) {
      throw Exception('Citizen ID not found. Please log in again.');
    }
    return citizenId;
  }

  Future<String?> _getCurrentUserDistrictId() async {
    // Get district ID from local storage
    final districtId = await authLocalDataSource.getCitizenDistrictId();
    if (districtId == null || districtId.isEmpty) {
      throw Exception('District ID not found. Please log in again.');
    }
    return districtId;
  }

}