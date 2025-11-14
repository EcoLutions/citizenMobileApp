enum ReportType {
  containerFull,
  containerDamaged,
  garbageOutside,
  missedCollection,
  other;

  String get displayName {
    switch (this) {
      case ReportType.containerFull:
        return 'Contenedor Lleno';
      case ReportType.containerDamaged:
        return 'Contenedor Dañado';
      case ReportType.garbageOutside:
        return 'Basura en la calle';
      case ReportType.missedCollection:
        return 'Recolección Perdida';
      case ReportType.other:
        return 'Otro';
    }
  }

  String get apiValue {
    switch (this) {
      case ReportType.containerFull:
        return 'CONTAINER_FULL';
      case ReportType.containerDamaged:
        return 'CONTAINER_DAMAGED';
      case ReportType.garbageOutside:
        return 'GARBAGE_OUTSIDE';
      case ReportType.missedCollection:
        return 'MISSED_COLLECTION';
      case ReportType.other:
        return 'OTHER';
    }
  }

  static ReportType fromApiValue(String value) {
    switch (value) {
      case 'CONTAINER_FULL':
        return ReportType.containerFull;
      case 'CONTAINER_DAMAGED':
        return ReportType.containerDamaged;
      case 'GARBAGE_OUTSIDE':
        return ReportType.garbageOutside;
      case 'MISSED_COLLECTION':
        return ReportType.missedCollection;
      case 'OTHER':
        return ReportType.other;
      default:
        return ReportType.other;
    }
  }
}