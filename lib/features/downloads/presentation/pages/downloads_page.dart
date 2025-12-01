import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/models/downloaded_lesson_model.dart';
import 'package:lms/core/services/download_manager_service.dart';
import 'package:lms/core/services/offline_storage_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/common_app_bar.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/presentation/widgets/course_detail_header.dart';
import 'package:intl/intl.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<DownloadedLessonModel> _downloadedLessons = [];
  Map<String, List<DownloadedLessonModel>> _lessonsByCourse = {};
  bool _isLoading = true;
  String? _selectedCourseId; // Track selected course for header display
  CourseDetailModel? _selectedCourseDetail;
  final GlobalKey<CourseDetailHeaderState> _headerKey = GlobalKey<CourseDetailHeaderState>();

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  void _loadDownloads() {
    setState(() {
      _isLoading = true;
    });

    final allLessons = OfflineStorageService.getAllDownloadedLessons();
    final completedLessons = allLessons.where((lesson) => lesson.isDownloaded).toList();

    // Group by course
    final Map<String, List<DownloadedLessonModel>> grouped = {};
    for (var lesson in completedLessons) {
      if (!grouped.containsKey(lesson.courseId)) {
        grouped[lesson.courseId] = [];
      }
      grouped[lesson.courseId]!.add(lesson);
    }

    setState(() {
      _downloadedLessons = completedLessons;
      _lessonsByCourse = grouped;
      _isLoading = false;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _deleteCourseDownloads(String courseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Downloads'),
        content: Text(
          'Are you sure you want to delete all downloaded lessons for this course?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final lessons = _lessonsByCourse[courseId] ?? [];
      int deletedCount = 0;

      for (var lesson in lessons) {
        final deleted = await DownloadManagerService().deleteDownloadedLesson(
          courseId: lesson.courseId,
          lessonId: lesson.lessonId,
        );
        if (deleted) deletedCount++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted $deletedCount lesson(s)'),
          ),
        );
        _loadDownloads();
      }
    }
  }

  Future<void> _deleteLesson(DownloadedLessonModel lesson) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: const Text('Are you sure you want to delete this downloaded lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final deleted = await DownloadManagerService().deleteDownloadedLesson(
        courseId: lesson.courseId,
        lessonId: lesson.lessonId,
      );

      if (deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download deleted')),
        );
        _loadDownloads();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WhiteAppBar(
        title: 'Downloads',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : _downloadedLessons.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async => _loadDownloads(),
                  child: Column(
                    children: [
                      // Course Detail Header (replaces storage info)
                      if (_selectedCourseDetail != null)
                        CourseDetailHeader(
                          key: _headerKey,
                          courseDetail: _selectedCourseDetail!,
                          onContentLoaded: () {}, // Optional callback
                        ),
                      // Downloads list
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: _lessonsByCourse.length,
                          itemBuilder: (context, index) {
                            final courseId = _lessonsByCourse.keys.elementAt(index);
                            final lessons = _lessonsByCourse[courseId]!;
                            final courseTitle = lessons.first.courseTitle ?? 'Course $courseId';
                            final totalSize = lessons.fold(0, (sum, l) => sum + l.fileSize);

                            return _buildCourseSection(
                              courseId: courseId,
                              courseTitle: courseTitle,
                              lessons: lessons,
                              totalSize: totalSize,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_outlined,
            size: 64.w,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Downloads',
            style: AppTheme.titleLarge.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Downloaded lessons will appear here',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _loadCourseDetail(String courseId) {
    final courseDetailJson = OfflineStorageService.getCourseDetailJson(courseId);
    if (courseDetailJson != null) {
      try {
        final jsonMap = jsonDecode(courseDetailJson) as Map<String, dynamic>;
        final courseDetail = CourseDetailModel.fromJson(jsonMap);
        setState(() {
          _selectedCourseId = courseId;
          _selectedCourseDetail = courseDetail;
        });
      } catch (e) {
        // If parsing fails, clear selection
        setState(() {
          _selectedCourseId = null;
          _selectedCourseDetail = null;
        });
      }
    } else {
      setState(() {
        _selectedCourseId = null;
        _selectedCourseDetail = null;
      });
    }
  }

  void _playDownloadedVideo(DownloadedLessonModel lesson) {
    // Play the downloaded video
    final headerState = _headerKey.currentState;
    if (headerState != null && lesson.filePath.isNotEmpty) {
      // Convert local file path to file:// URI
      final fileUri = lesson.filePath.startsWith('file://') 
          ? lesson.filePath 
          : 'file://${lesson.filePath}';
      
      headerState.playVideo(
        fileUri,
        storage: 'upload', // Downloaded videos are always 'upload' type
        startTime: 0.0,
        courseId: lesson.courseId,
        lessonId: lesson.lessonId,
      );
    }
  }

  Widget _buildCourseSection({
    required String courseId,
    required String courseTitle,
    required List<DownloadedLessonModel> lessons,
    required int totalSize,
  }) {
    final isSelected = _selectedCourseId == courseId;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseTitle,
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${lessons.length} lesson(s) • ${_formatFileSize(totalSize)}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteCourseDownloads(courseId),
                  tooltip: 'Delete all downloads',
                ),
                IconButton(
                  icon: Icon(isSelected ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    if (isSelected) {
                      // Hide header
                      setState(() {
                        _selectedCourseId = null;
                        _selectedCourseDetail = null;
                      });
                    } else {
                      // Show header for this course
                      _loadCourseDetail(courseId);
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.borderColor),
          // Lessons list
          ...lessons.map((lesson) => _buildLessonItem(lesson)),
        ],
      ),
    );
  }

  Widget _buildLessonItem(DownloadedLessonModel lesson) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: Icon(
        Icons.play_circle_outline,
        color: AppTheme.primaryColor,
        size: 24.w,
      ),
      title: Text(
        lesson.lessonTitle ?? 'Lesson ${lesson.lessonId}',
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Text(
            '${_formatFileSize(lesson.fileSize)} • Downloaded ${dateFormat.format(lesson.downloadedAt)}',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 20),
        color: Colors.red,
        onPressed: () => _deleteLesson(lesson),
      ),
      onTap: () {
        // Load course detail header if not already loaded
        if (_selectedCourseId != lesson.courseId) {
          _loadCourseDetail(lesson.courseId);
          
          // Wait for header to load, then play video
          Future.delayed(const Duration(milliseconds: 100), () {
            _playDownloadedVideo(lesson);
          });
        } else {
          // Play immediately if header is already loaded
          _playDownloadedVideo(lesson);
        }
      },
    );
  }
}

