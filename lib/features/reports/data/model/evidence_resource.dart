class EvidenceResource {
  final String id;
  final String type;
  final String originalFileName;
  final String fileUrl;
  final String? thumbnailUrl;
  final String? description;
  final int fileSize;
  final String mimeType;
  final String createdAt;

  const EvidenceResource({
    required this.id,
    required this.type,
    required this.originalFileName,
    required this.fileUrl,
    this.thumbnailUrl,
    this.description,
    required this.fileSize,
    required this.mimeType,
    required this.createdAt,
  });

  factory EvidenceResource.fromJson(Map<String, dynamic> json) {
    return EvidenceResource(
      id: json['id'] as String,
      type: json['type'] as String,
      originalFileName: json['originalFileName'] as String,
      fileUrl: json['fileUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      description: json['description'] as String?,
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'originalFileName': originalFileName,
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'createdAt': createdAt,
    };
  }
}