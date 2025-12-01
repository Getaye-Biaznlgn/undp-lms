import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/models/download_status.dart';
import 'package:lms/core/services/download_manager_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/domain/usecases/get_lesson_file_info_usecase.dart';
import 'package:lms/dependency_injection.dart';
import 'package:logger/logger.dart';

class DownloadButton extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String videoUrl;
  final String? lessonTitle;
  final String? courseTitle;
  final String? courseSlug; // Course slug for navigation
  final String? storage; // 'external_link' for YouTube, 'upload' for regular videos
  final CourseDetailModel? courseDetail; // Course detail model for saving

  const DownloadButton({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.videoUrl,
    this.lessonTitle,
    this.courseTitle,
    this.courseSlug,
    this.storage,
    this.courseDetail,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final Logger _logger = Logger();
  DownloadStatus? _downloadStatus;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkDownloadStatus();
  }

  void _checkDownloadStatus() {
    final status = DownloadManagerService().getDownloadStatus(
      courseId: widget.courseId,
      lessonId: widget.lessonId,
    );

    final progress = DownloadManagerService().getDownloadProgress(
      courseId: widget.courseId,
      lessonId: widget.lessonId,
    );

    if (mounted) {
      setState(() {
        _downloadStatus = status;
        _progress = progress ?? 0.0;
      });
    }
  }

  bool get _isDownloaded => _downloadStatus == DownloadStatus.completed;
  bool get _isDownloading => _downloadStatus == DownloadStatus.downloading;
  bool get _canDownload => widget.storage != 'external_link' && 
                          _downloadStatus != DownloadStatus.downloading &&
                          _downloadStatus != DownloadStatus.completed;

  Future<void> _handleDownload() async {
    // Get video URL if not provided
    String videoUrl = widget.videoUrl;
    String? storage = widget.storage;
    
    // If video URL is empty, fetch file info
    if (videoUrl.isEmpty) {
      try {
        final getFileInfoUseCase = sl<GetLessonFileInfoUseCase>();
        final fileInfoResult = await getFileInfoUseCase(
          courseId: widget.courseId,
          lessonId: widget.lessonId,
        );
        
        bool fetchSuccess = false;
        fileInfoResult.fold(
          (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to get file info: ${failure.message}')),
              );
            }
          },
          (fileInfoResponse) {
            videoUrl = fileInfoResponse.fileInfo.filePath;
            storage = fileInfoResponse.fileInfo.storage;
            fetchSuccess = true;
          },
        );
        
        if (!fetchSuccess || videoUrl.isEmpty) {
          return;
        }
      } catch (e) {
        _logger.e('Error fetching file info: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get file information')),
          );
        }
        return;
      }
    }
    
    // Validate URL
    if (videoUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video URL is not available')),
        );
      }
      return;
    }
    
    // Skip YouTube videos (cannot be downloaded)
    if (storage == 'external_link') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('YouTube videos cannot be downloaded offline'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (_isDownloaded) {
      // Show delete confirmation
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
          courseId: widget.courseId,
          lessonId: widget.lessonId,
        );

        if (deleted && mounted) {
          setState(() {
            _downloadStatus = null;
            _progress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download deleted')),
          );
        }
      }
    } else if (_isDownloading) {
      // Pause download
      await DownloadManagerService().pauseDownload(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
      );
      _checkDownloadStatus();
    } else {
      // Convert CourseDetailModel to JSON if available
      String? courseDetailJson;
      if (widget.courseDetail != null) {
        try {
          courseDetailJson = jsonEncode(widget.courseDetail!.toJson());
        } catch (e) {
          _logger.e('Error encoding course detail: $e');
        }
      }
      
      // Start download - use the fetched videoUrl
      final success = await DownloadManagerService().downloadLesson(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        videoUrl: videoUrl, // Use the fetched URL
        lessonTitle: widget.lessonTitle,
        courseTitle: widget.courseTitle,
        courseSlug: widget.courseSlug, // Pass course slug
        courseDetailJson: courseDetailJson, // Pass course detail JSON
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _progress = progress;
            });
          }
        },
        onStatusChanged: (status) {
          if (mounted) {
            setState(() {
              _downloadStatus = status;
            });
          }
        },
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download failed. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_canDownload && !_isDownloaded && !_isDownloading) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _handleDownload,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: _isDownloaded 
              ? Colors.green.withOpacity(0.1)
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isDownloading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: _progress > 0 ? _progress : null,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              )
            else if (_isDownloaded)
              Icon(
                Icons.check_circle,
                size: 16.w,
                color: Colors.green,
              )
            else
              Icon(
                Icons.download,
                size: 16.w,
                color: AppTheme.primaryColor,
              ),
            if (_isDownloading && _progress > 0) ...[
              SizedBox(width: 8.w),
              Text(
                '${(_progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

