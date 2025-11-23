class ReportResource {
  final String id;
  final String citizenId;
  final String districtId;
  final String latitude;
  final String longitude;
  final String? address;
  final String? districtCode;
  final String? containerId;
  final String reportType;
  final String description;
  final String status;
  final String? resolutionNote;
  final String? resolvedAt;
  final String? resolvedBy;
  final String submittedAt;
  final String? acknowledgedAt;
  final String createdAt;
  final String updatedAt;

  const ReportResource({
    required this.id,
    required this.citizenId,
    required this.districtId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.districtCode,
    this.containerId,
    required this.reportType,
    required this.description,
    required this.status,
    this.resolutionNote,
    this.resolvedAt,
    this.resolvedBy,
    required this.submittedAt,
    this.acknowledgedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportResource.fromJson(Map<String, dynamic> json) {
    return ReportResource(
      id: json['id'] as String,
      citizenId: json['citizenId'] as String,
      districtId: json['districtId'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      address: json['address'] as String?,
      districtCode: json['districtCode'] as String?,
      containerId: json['containerId'] as String?,
      reportType: json['reportType'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      resolutionNote: json['resolutionNote'] as String?,
      resolvedAt: json['resolvedAt'] as String?,
      resolvedBy: json['resolvedBy'] as String?,
      submittedAt: json['submittedAt'] as String,
      acknowledgedAt: json['acknowledgedAt'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizenId': citizenId,
      'districtId': districtId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'districtCode': districtCode,
      'containerId': containerId,
      'reportType': reportType,
      'description': description,
      'status': status,
      'resolutionNote': resolutionNote,
      'resolvedAt': resolvedAt,
      'resolvedBy': resolvedBy,
      'submittedAt': submittedAt,
      'acknowledgedAt': acknowledgedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}