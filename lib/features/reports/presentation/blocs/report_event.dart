import 'dart:io';

abstract class ReportEvent {}

class ReportTypeChanged extends ReportEvent {
  final String type;
  ReportTypeChanged(this.type);
}

class DescriptionChanged extends ReportEvent {
  final String description;
  DescriptionChanged(this.description);
}

class AddPhoto extends ReportEvent {}

class RemovePhoto extends ReportEvent {
  final File photo;
  RemovePhoto(this.photo);
}

class SubmitReport extends ReportEvent {}