import 'package:hive/hive.dart';
import 'package:lms/core/models/download_status.dart';

part 'downloaded_lesson_model.g.dart';

@HiveType(typeId: 0)
class DownloadedLessonModel {
  @HiveField(0)
  final String courseId;

  @HiveField(1)
  final String lessonId;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final String originalUrl;

  @HiveField(4)
  final String status; // DownloadStatus as string

  @HiveField(5)
  final double progress; // 0.0 to 1.0

  @HiveField(6)
  final int fileSize; // in bytes

  @HiveField(7)
  final DateTime downloadedAt;

  @HiveField(8)
  final String? errorMessage;

  @HiveField(9)
  final String? lessonTitle;

  @HiveField(10)
  final String? courseTitle;

  @HiveField(11)
  final String? courseSlug; // Course slug for navigation

  @HiveField(12)
  final String? courseDetailJson; // CourseDetailModel as JSON string

  DownloadedLessonModel({
    required this.courseId,
    required this.lessonId,
    required this.filePath,
    required this.originalUrl,
    required this.status,
    required this.progress,
    required this.fileSize,
    required this.downloadedAt,
    this.errorMessage,
    this.lessonTitle,
    this.courseTitle,
    this.courseSlug,
    this.courseDetailJson,
  });

  DownloadStatus get downloadStatus => DownloadStatusExtension.fromString(status);

  bool get isDownloaded => downloadStatus == DownloadStatus.completed;

  bool get isDownloading => downloadStatus == DownloadStatus.downloading;

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'lessonId': lessonId,
      'filePath': filePath,
      'originalUrl': originalUrl,
      'status': status,
      'progress': progress,
      'fileSize': fileSize,
      'downloadedAt': downloadedAt.toIso8601String(),
      'errorMessage': errorMessage,
      'lessonTitle': lessonTitle,
      'courseTitle': courseTitle,
      'courseSlug': courseSlug,
      'courseDetailJson': courseDetailJson,
    };
  }

  factory DownloadedLessonModel.fromJson(Map<String, dynamic> json) {
    return DownloadedLessonModel(
      courseId: json['courseId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      filePath: json['filePath'] ?? '',
      originalUrl: json['originalUrl'] ?? '',
      status: json['status'] ?? 'pending',
      progress: (json['progress'] ?? 0.0).toDouble(),
      fileSize: json['fileSize'] ?? 0,
      downloadedAt: json['downloadedAt'] != null
          ? DateTime.parse(json['downloadedAt'])
          : DateTime.now(),
      errorMessage: json['errorMessage'],
      lessonTitle: json['lessonTitle'],
      courseTitle: json['courseTitle'],
      courseSlug: json['courseSlug'],
      courseDetailJson: json['courseDetailJson'],
    );
  }

  DownloadedLessonModel copyWith({
    String? courseId,
    String? lessonId,
    String? filePath,
    String? originalUrl,
    String? status,
    double? progress,
    int? fileSize,
    DateTime? downloadedAt,
    String? errorMessage,
    String? lessonTitle,
    String? courseTitle,
    String? courseSlug,
    String? courseDetailJson,
  }) {
    return DownloadedLessonModel(
      courseId: courseId ?? this.courseId,
      lessonId: lessonId ?? this.lessonId,
      filePath: filePath ?? this.filePath,
      originalUrl: originalUrl ?? this.originalUrl,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      fileSize: fileSize ?? this.fileSize,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      courseTitle: courseTitle ?? this.courseTitle,
      courseSlug: courseSlug ?? this.courseSlug,
      courseDetailJson: courseDetailJson ?? this.courseDetailJson,
    );
  }
}

