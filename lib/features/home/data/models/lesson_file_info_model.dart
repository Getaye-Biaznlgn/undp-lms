class LessonFileInfoModel {
  final int id;
  final String filePath;
  final String storage;
  final String fileType;
  final String downloadable;
  final String? description;
  final String type;

  LessonFileInfoModel({
    required this.id,
    required this.filePath,
    required this.storage,
    required this.fileType,
    required this.downloadable,
    this.description,
    required this.type,
  });

  factory LessonFileInfoModel.fromJson(Map<String, dynamic> json) {
    return LessonFileInfoModel(
      id: json['id'] ?? 0,
      filePath: json['file_path'] ?? '',
      storage: json['storage'] ?? '',
      fileType: json['file_type'] ?? '',
      downloadable: json['downloadable'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_path': filePath,
      'storage': storage,
      'file_type': fileType,
      'downloadable': downloadable,
      'description': description,
      'type': type,
    };
  }
}

class LessonFileInfoResponse {
  final LessonFileInfoModel fileInfo;

  LessonFileInfoResponse({
    required this.fileInfo,
  });

  factory LessonFileInfoResponse.fromJson(Map<String, dynamic> json) {
    return LessonFileInfoResponse(
      fileInfo: LessonFileInfoModel.fromJson(json['file_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_info': fileInfo.toJson(),
    };
  }
}


