import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lms/core/models/download_status.dart';
import 'package:lms/core/models/downloaded_lesson_model.dart';
import 'package:lms/core/services/offline_storage_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

typedef DownloadProgressCallback = void Function(double progress);
typedef DownloadStatusCallback = void Function(DownloadStatus status);

class DownloadManagerService {
  static final DownloadManagerService _instance = DownloadManagerService._internal();
  factory DownloadManagerService() => _instance;
  DownloadManagerService._internal();

  final Logger _logger = Logger();
  final Dio _dio = Dio();
  final Map<String, CancelToken> _activeDownloads = {};
  final Map<String, DownloadProgressCallback> _progressCallbacks = {};
  final Map<String, DownloadStatusCallback> _statusCallbacks = {};

  static const int maxConcurrentDownloads = 3;
  int _currentDownloads = 0;

  /// Initialize download manager
  Future<void> init() async {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
    _logger.d('DownloadManagerService initialized');
  }

  /// Download a lesson video
  Future<bool> downloadLesson({
    required String courseId,
    required String lessonId,
    required String videoUrl,
    String? lessonTitle,
    String? courseTitle,
    String? courseSlug, // Course slug for navigation
    String? courseDetailJson, // CourseDetailModel as JSON string
    DownloadProgressCallback? onProgress,
    DownloadStatusCallback? onStatusChanged,
  }) async {
    final key = _generateKey(courseId, lessonId);

    // Validate URL
    if (videoUrl.isEmpty) {
      _logger.e('Video URL is empty');
      onStatusChanged?.call(DownloadStatus.failed);
      return false;
    }

    // Parse and validate URL - handle spaces in URL
    Uri? uri;
    try {
      // First try parsing as-is
      uri = Uri.parse(videoUrl);
      
      // If parsing fails or host is empty, try encoding the path
      if (uri.host.isEmpty) {
        // Try to manually encode the URL
        final parts = videoUrl.split('://');
        if (parts.length == 2) {
          final scheme = parts[0];
          final rest = parts[1];
          final hostAndPath = rest.split('/');
          final host = hostAndPath[0];
          final pathSegments = hostAndPath.sublist(1);
          
          // Encode each path segment
          final encodedPathSegments = pathSegments.map((segment) {
            return Uri.encodeComponent(segment);
          }).toList();
          
          uri = Uri(
            scheme: scheme,
            host: host,
            pathSegments: encodedPathSegments,
          );
        }
        
        if (uri.host.isEmpty) {
          _logger.e('Invalid URL: No host specified - $videoUrl');
          onStatusChanged?.call(DownloadStatus.failed);
          return false;
        }
      }
    } catch (e) {
      _logger.e('Error parsing URL: $e - $videoUrl');
      onStatusChanged?.call(DownloadStatus.failed);
      return false;
    }

    // Check if already downloaded
    if (OfflineStorageService.isLessonDownloaded(
      courseId: courseId,
      lessonId: lessonId,
    )) {
      _logger.d('Lesson already downloaded: $lessonId');
      return true;
    }

    // Check if already downloading
    if (_activeDownloads.containsKey(key)) {
      _logger.w('Download already in progress: $lessonId');
      return false;
    }

    // Check concurrent download limit
    if (_currentDownloads >= maxConcurrentDownloads) {
      _logger.w('Max concurrent downloads reached');
      // Save as pending
      await _savePendingDownload(
        courseId: courseId,
        lessonId: lessonId,
        videoUrl: videoUrl,
        lessonTitle: lessonTitle,
        courseTitle: courseTitle,
        courseSlug: courseSlug,
        courseDetailJson: courseDetailJson,
      );
      return false;
    }

    try {
      // Update status to downloading
      await _updateStatus(
        courseId: courseId,
        lessonId: lessonId,
        status: DownloadStatus.downloading,
      );
      onStatusChanged?.call(DownloadStatus.downloading);

      // Store callbacks
      if (onProgress != null) {
        _progressCallbacks[key] = onProgress;
      }
      if (onStatusChanged != null) {
        _statusCallbacks[key] = onStatusChanged;
      }

      _currentDownloads++;

      // Get file path
      final filePath = await _getFilePath(courseId, lessonId, videoUrl);

      // Create cancel token
      final cancelToken = CancelToken();
      _activeDownloads[key] = cancelToken;

      // Use the properly encoded URI
      final downloadUrl = uri.toString();
      _logger.d('Downloading from: $downloadUrl (original: $videoUrl)');

      // Download file
      await _dio.download(
        downloadUrl,
        filePath,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            _progressCallbacks[key]?.call(progress);
            _updateProgress(
              courseId: courseId,
              lessonId: lessonId,
              progress: progress,
            );
          }
        },
      );

      // Verify file exists and has content
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Downloaded file does not exist');
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        throw Exception('Downloaded file is empty');
      }

      // Save as completed
      await _saveCompletedDownload(
        courseId: courseId,
        lessonId: lessonId,
        videoUrl: videoUrl,
        filePath: filePath,
        fileSize: fileSize,
        lessonTitle: lessonTitle,
        courseTitle: courseTitle,
        courseSlug: courseSlug,
        courseDetailJson: courseDetailJson,
      );

      _logger.d('Download completed: $lessonId, size: $fileSize bytes');

      // Cleanup
      _activeDownloads.remove(key);
      _progressCallbacks.remove(key);
      _statusCallbacks.remove(key);
      _currentDownloads--;

      onStatusChanged?.call(DownloadStatus.completed);
      return true;
    } catch (e) {
      _logger.e('Download error: $e');

      // Save as failed
      await _updateStatus(
        courseId: courseId,
        lessonId: lessonId,
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );

      // Cleanup
      _activeDownloads.remove(key);
      _progressCallbacks.remove(key);
      _statusCallbacks.remove(key);
      _currentDownloads--;

      onStatusChanged?.call(DownloadStatus.failed);
      return false;
    }
  }

  /// Pause download
  Future<void> pauseDownload({
    required String courseId,
    required String lessonId,
  }) async {
    final key = _generateKey(courseId, lessonId);
    final cancelToken = _activeDownloads[key];

    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Paused by user');
      _activeDownloads.remove(key);
      _currentDownloads--;

      await _updateStatus(
        courseId: courseId,
        lessonId: lessonId,
        status: DownloadStatus.paused,
      );

      _statusCallbacks[key]?.call(DownloadStatus.paused);
      _statusCallbacks.remove(key);
      _progressCallbacks.remove(key);
    }
  }

  /// Cancel download
  Future<void> cancelDownload({
    required String courseId,
    required String lessonId,
  }) async {
    final key = _generateKey(courseId, lessonId);
    final cancelToken = _activeDownloads[key];

    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Cancelled by user');
      _activeDownloads.remove(key);
      _currentDownloads--;

      await _updateStatus(
        courseId: courseId,
        lessonId: lessonId,
        status: DownloadStatus.cancelled,
      );

      // Delete partial file
      final lesson = OfflineStorageService.getDownloadedLesson(
        courseId: courseId,
        lessonId: lessonId,
      );
      if (lesson != null) {
        try {
          final file = File(lesson.filePath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          _logger.e('Error deleting partial file: $e');
        }
      }

      _statusCallbacks[key]?.call(DownloadStatus.cancelled);
      _statusCallbacks.remove(key);
      _progressCallbacks.remove(key);
    }
  }

  /// Delete downloaded lesson
  Future<bool> deleteDownloadedLesson({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final lesson = OfflineStorageService.getDownloadedLesson(
        courseId: courseId,
        lessonId: lessonId,
      );

      if (lesson != null) {
        // Delete file
        final file = File(lesson.filePath);
        if (await file.exists()) {
          await file.delete();
        }

        // Delete from storage
        await OfflineStorageService.deleteDownloadedLesson(
          courseId: courseId,
          lessonId: lessonId,
        );

        _logger.d('Deleted downloaded lesson: $lessonId');
        return true;
      }
      return false;
    } catch (e) {
      _logger.e('Error deleting downloaded lesson: $e');
      return false;
    }
  }

  /// Get download status
  DownloadStatus? getDownloadStatus({
    required String courseId,
    required String lessonId,
  }) {
    final lesson = OfflineStorageService.getDownloadedLesson(
      courseId: courseId,
      lessonId: lessonId,
    );

    if (lesson == null) {
      return null;
    }

    // Check if currently downloading
    final key = _generateKey(courseId, lessonId);
    if (_activeDownloads.containsKey(key)) {
      return DownloadStatus.downloading;
    }

    return lesson.downloadStatus;
  }

  /// Get download progress
  double? getDownloadProgress({
    required String courseId,
    required String lessonId,
  }) {
    final lesson = OfflineStorageService.getDownloadedLesson(
      courseId: courseId,
      lessonId: lessonId,
    );
    return lesson?.progress;
  }

  /// Get file path for download
  Future<String> _getFilePath(String courseId, String lessonId, String videoUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final coursesDir = Directory('${directory.path}/courses/$courseId/lessons');
    
    if (!await coursesDir.exists()) {
      await coursesDir.create(recursive: true);
    }

    // Extract file extension from URL or use .mp4 as default
    final uri = Uri.parse(videoUrl);
    final pathSegments = uri.pathSegments;
    final fileName = pathSegments.isNotEmpty 
        ? pathSegments.last 
        : '$lessonId.mp4';
    
    // Clean filename and ensure it has extension
    final cleanFileName = fileName.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
    final hasExtension = cleanFileName.contains('.');
    final finalFileName = hasExtension ? cleanFileName : '$cleanFileName.mp4';

    return '${coursesDir.path}/$finalFileName';
  }

  /// Save pending download
  Future<void> _savePendingDownload({
    required String courseId,
    required String lessonId,
    required String videoUrl,
    String? lessonTitle,
    String? courseTitle,
    String? courseSlug,
    String? courseDetailJson,
  }) async {
    final filePath = await _getFilePath(courseId, lessonId, videoUrl);
    
    final lesson = DownloadedLessonModel(
      courseId: courseId,
      lessonId: lessonId,
      filePath: filePath,
      originalUrl: videoUrl,
      status: DownloadStatus.pending.name,
      progress: 0.0,
      fileSize: 0,
      downloadedAt: DateTime.now(),
      lessonTitle: lessonTitle,
      courseTitle: courseTitle,
      courseSlug: courseSlug,
      courseDetailJson: courseDetailJson,
    );

    await OfflineStorageService.saveDownloadedLesson(lesson);
  }

  /// Save completed download
  Future<void> _saveCompletedDownload({
    required String courseId,
    required String lessonId,
    required String videoUrl,
    required String filePath,
    required int fileSize,
    String? lessonTitle,
    String? courseTitle,
    String? courseSlug,
    String? courseDetailJson,
  }) async {
    final lesson = DownloadedLessonModel(
      courseId: courseId,
      lessonId: lessonId,
      filePath: filePath,
      originalUrl: videoUrl,
      status: DownloadStatus.completed.name,
      progress: 1.0,
      fileSize: fileSize,
      downloadedAt: DateTime.now(),
      lessonTitle: lessonTitle,
      courseTitle: courseTitle,
      courseSlug: courseSlug,
      courseDetailJson: courseDetailJson,
    );

    await OfflineStorageService.saveDownloadedLesson(lesson);
  }

  /// Update download status
  Future<void> _updateStatus({
    required String courseId,
    required String lessonId,
    required DownloadStatus status,
    String? errorMessage,
  }) async {
    final existing = OfflineStorageService.getDownloadedLesson(
      courseId: courseId,
      lessonId: lessonId,
    );

    if (existing != null) {
      await OfflineStorageService.saveDownloadedLesson(
        existing.copyWith(
          status: status.name,
          errorMessage: errorMessage,
        ),
      );
    } else {
      // Create new entry
      final filePath = await _getFilePath(courseId, lessonId, '');
      final lesson = DownloadedLessonModel(
        courseId: courseId,
        lessonId: lessonId,
        filePath: filePath,
        originalUrl: '',
        status: status.name,
        progress: 0.0,
        fileSize: 0,
        downloadedAt: DateTime.now(),
        errorMessage: errorMessage,
      );
      await OfflineStorageService.saveDownloadedLesson(lesson);
    }
  }

  /// Update download progress
  Future<void> _updateProgress({
    required String courseId,
    required String lessonId,
    required double progress,
  }) async {
    await OfflineStorageService.updateDownloadProgress(
      courseId: courseId,
      lessonId: lessonId,
      progress: progress,
    );
  }

  /// Generate unique key
  String _generateKey(String courseId, String lessonId) {
    return '${courseId}_$lessonId';
  }
}

