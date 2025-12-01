import 'package:hive_flutter/hive_flutter.dart';
import 'package:lms/core/models/downloaded_lesson_model.dart';
import 'package:logger/logger.dart';

class OfflineStorageService {
  static const String _boxName = 'downloaded_lessons';
  static Box<DownloadedLessonModel>? _box;
  static final Logger _logger = Logger();

  /// Initialize Hive and open the box
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      // Register adapter
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DownloadedLessonModelAdapter());
      }
      
      _box = await Hive.openBox<DownloadedLessonModel>(_boxName);
      _logger.d('OfflineStorageService initialized');
    } catch (e) {
      _logger.e('Error initializing OfflineStorageService: $e');
      rethrow;
    }
  }

  /// Get all downloaded lessons
  static List<DownloadedLessonModel> getAllDownloadedLessons() {
    if (_box == null) {
      _logger.w('Box not initialized');
      return [];
    }
    return _box!.values.toList();
  }

  /// Get downloaded lesson by course and lesson ID
  static DownloadedLessonModel? getDownloadedLesson({
    required String courseId,
    required String lessonId,
  }) {
    if (_box == null) {
      _logger.w('Box not initialized');
      return null;
    }

    try {
      final key = _generateKey(courseId, lessonId);
      return _box!.get(key);
    } catch (e) {
      _logger.e('Error getting downloaded lesson: $e');
      return null;
    }
  }

  /// Check if lesson is downloaded
  static bool isLessonDownloaded({
    required String courseId,
    required String lessonId,
  }) {
    final lesson = getDownloadedLesson(
      courseId: courseId,
      lessonId: lessonId,
    );
    return lesson != null && lesson.isDownloaded;
  }

  /// Get local file path for downloaded lesson
  static String? getLocalFilePath({
    required String courseId,
    required String lessonId,
  }) {
    final lesson = getDownloadedLesson(
      courseId: courseId,
      lessonId: lessonId,
    );
    
    if (lesson != null && lesson.isDownloaded) {
      return lesson.filePath;
    }
    return null;
  }

  /// Save downloaded lesson
  static Future<void> saveDownloadedLesson(DownloadedLessonModel lesson) async {
    if (_box == null) {
      _logger.w('Box not initialized');
      return;
    }

    try {
      final key = _generateKey(lesson.courseId, lesson.lessonId);
      await _box!.put(key, lesson);
      _logger.d('Saved downloaded lesson: ${lesson.lessonId}');
    } catch (e) {
      _logger.e('Error saving downloaded lesson: $e');
      rethrow;
    }
  }

  /// Update download progress
  static Future<void> updateDownloadProgress({
    required String courseId,
    required String lessonId,
    required double progress,
    String? status,
  }) async {
    if (_box == null) {
      _logger.w('Box not initialized');
      return;
    }

    try {
      final key = _generateKey(courseId, lessonId);
      final existing = _box!.get(key);
      
      if (existing != null) {
        await _box!.put(
          key,
          existing.copyWith(
            progress: progress,
            status: status ?? existing.status,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error updating download progress: $e');
    }
  }

  /// Delete downloaded lesson
  static Future<void> deleteDownloadedLesson({
    required String courseId,
    required String lessonId,
  }) async {
    if (_box == null) {
      _logger.w('Box not initialized');
      return;
    }

    try {
      final key = _generateKey(courseId, lessonId);
      await _box!.delete(key);
      _logger.d('Deleted downloaded lesson: $lessonId');
    } catch (e) {
      _logger.e('Error deleting downloaded lesson: $e');
      rethrow;
    }
  }

  /// Get all downloaded lessons for a course
  static List<DownloadedLessonModel> getDownloadedLessonsForCourse(String courseId) {
    if (_box == null) {
      _logger.w('Box not initialized');
      return [];
    }

    return _box!.values
        .where((lesson) => lesson.courseId == courseId)
        .toList();
  }

  /// Get CourseDetailModel JSON for a course
  static String? getCourseDetailJson(String courseId) {
    if (_box == null) {
      _logger.w('Box not initialized');
      return null;
    }

    final lessons = _box!.values
        .where((lesson) => lesson.courseId == courseId && lesson.isDownloaded)
        .toList();

    if (lessons.isEmpty) {
      return null;
    }

    // Return the courseDetailJson from the first lesson (all should have the same)
    return lessons.first.courseDetailJson;
  }

  /// Get total storage used by downloaded lessons
  static int getTotalStorageUsed() {
    if (_box == null) {
      return 0;
    }

    return _box!.values
        .where((lesson) => lesson.isDownloaded)
        .fold(0, (sum, lesson) => sum + lesson.fileSize);
  }

  /// Clear all downloaded lessons
  static Future<void> clearAll() async {
    if (_box == null) {
      return;
    }

    await _box!.clear();
    _logger.d('Cleared all downloaded lessons');
  }

  /// Generate unique key for course and lesson
  static String _generateKey(String courseId, String lessonId) {
    return '${courseId}_$lessonId';
  }
}

