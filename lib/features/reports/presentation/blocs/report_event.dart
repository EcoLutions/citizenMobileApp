import 'dart:io';
import 'package:citizen_mobile_app/features/reports/domain/entities/report_type.dart';
import 'package:image_picker/image_picker.dart';

abstract class ReportEvent {}

class ReportTypeChanged extends ReportEvent {
  final ReportType type;
  ReportTypeChanged(this.type);
}

class DescriptionChanged extends ReportEvent {
  final String description;
  DescriptionChanged(this.description);
}

class LocationChanged extends ReportEvent {
  final double latitude;
  final double longitude;
  LocationChanged(this.latitude, this.longitude);
}

class AddPhoto extends ReportEvent {
  final ImageSource source;
  AddPhoto(this.source);
}

class RemovePhoto extends ReportEvent {
  final File photo;
  RemovePhoto(this.photo);
}

class SubmitReport extends ReportEvent {}

class ResetReportForm extends ReportEvent {}