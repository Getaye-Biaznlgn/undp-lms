import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:logger/logger.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:lms/features/home/presentation/pages/quiz_list_page.dart';
import 'package:lms/features/home/presentation/bloc/meeting_bloc.dart';
import 'package:lms/features/home/presentation/bloc/meeting_event.dart';
import 'package:lms/features/home/presentation/widgets/course_meetings_widget.dart';
import 'package:lms/features/home/domain/usecases/get_lesson_file_info_usecase.dart';
import 'package:lms/features/home/domain/usecases/get_lesson_progress_usecase.dart';
import 'package:lms/dependency_injection.dart';

class CourseDetailTabs extends StatefulWidget {
  final CourseDetailModel courseDetail;
  final Function(String, String, double)? onLessonTap; // (filePath, storage, startTime)

  const CourseDetailTabs({
    super.key,
    required this.courseDetail,
    this.onLessonTap,
  });

  @override
  State<CourseDetailTabs> createState() => _CourseDetailTabsState();
}

class _CourseDetailTabsState extends State<CourseDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _loadingLessonId; // Track which lesson is currently loading

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.animateTo(0); // Start with Overview tab
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // When Meetings tab (index 4) is selected, fetch meetings
      if (_tabController.index == 4) {
        context.read<MeetingBloc>().add(
              GetMeetingsByCourseIdEvent(
                courseId: widget.courseDetail.id.toString(),
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelColor: AppTheme.textPrimaryColor,
              unselectedLabelColor: AppTheme.textSecondaryColor,
              labelStyle: AppTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Curriculum'),
                Tab(text: 'Quizzes'),
                Tab(text: 'Meetings'),
                Tab(text: 'Reviews'),
              ],
            ),
          ),
          
          // Tab Content
          Container(
            height: 600.h, // Fixed height to prevent render box errors
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCurriculumTab(),
                _buildQuizzesTab(),
                _buildMeetingsTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Description',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          // Parse HTML description and display as rich text
          // For now, showing plain text
          Text(
            widget.courseDetail.description.replaceAll(RegExp(r'<[^>]*>'), ''),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    if (widget.courseDetail.curriculums.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 60.w,
              color: AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'No curriculum available',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.courseDetail.curriculums.length,
      itemBuilder: (context, index) {
        final curriculum = widget.courseDetail.curriculums[index];
        return _buildCurriculumItem(curriculum);
      },
    );
  }

  Widget _buildCurriculumItem(Curriculum curriculum) {
    if (curriculum.chapters.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          curriculum.title,
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      );
    }
    
    return ExpansionTile(
      title: Text(
        curriculum.title,
        style: AppTheme.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      children: curriculum.chapters.map((chapter) {
        return _buildChapterItem(chapter);
      }).toList(),
    );
  }

  Widget _buildChapterItem(Chapter chapter) {
    final isLesson = chapter.type == 'lesson';
    final item = chapter.item;
    final lessonId = item.id.toString();
    final isLoading = _loadingLessonId == lessonId;
    
    return GestureDetector(
      onTap: isLesson && item.fileType == 'video' && widget.onLessonTap != null && !isLoading
          ? () => _handleLessonTap(lessonId, widget.courseDetail.id)
          : null,
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // Icon or loading indicator
            if (isLoading)
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              )
            else
              Icon(
                isLesson ? Icons.play_circle_outline : Icons.quiz,
                size: 20.w,
                color: AppTheme.textSecondaryColor,
              ),
            SizedBox(width: 12.w),
            
            // Title and duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isLoading 
                          ? AppTheme.textSecondaryColor 
                          : AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isLesson && item.duration != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      item.duration!,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizzesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz,
            size: 60.w,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Test Your Knowledge',
            textAlign: TextAlign.center,
            style: AppTheme.titleLarge.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Take quizzes to assess your understanding of the course material',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuizStat(
                      icon: Icons.quiz,
                      label: 'Available',
                      value: '${widget.courseDetail.quizzesCount}',
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: AppTheme.dividerColor,
                    ),
                    _buildQuizStat(
                      icon: Icons.timer,
                      label: 'Timed',
                      value: 'Yes',
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: AppTheme.dividerColor,
                    ),
                    _buildQuizStat(
                      icon: Icons.check_circle,
                      label: 'Graded',
                      value: 'Yes',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizListPage(
                      courseId: widget.courseDetail.id.toString(),
                      courseTitle: widget.courseDetail.title,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'View All Quizzes',
                    style: AppTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24.w,
          color: AppTheme.primaryColor,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLessonTap(String lessonId, String courseId) async {
    try {
      if (!mounted) return;
      
      // Set loading state for this specific lesson
      setState(() {
        _loadingLessonId = lessonId;
      });
      
      // Fetch file info
      final getFileInfoUseCase = sl<GetLessonFileInfoUseCase>();
      final fileInfoResult = await getFileInfoUseCase(
        courseId: courseId,
        lessonId: lessonId,
      );

      fileInfoResult.fold(
        (failure) {
          Logger().e('Failed to get file info: ${failure.message}');
          if (mounted) {
            setState(() {
              _loadingLessonId = null; // Clear loading state on failure
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load lesson: ${failure.message}')),
            );
          }
        },
        (fileInfoResponse) async {
          final filePath = fileInfoResponse.fileInfo.filePath;
          final storage = fileInfoResponse.fileInfo.storage;
          
          // Fetch lesson progress
          final getProgressUseCase = sl<GetLessonProgressUseCase>();
          final progressResult = await getProgressUseCase(
            courseId: courseId,
            lessonId: lessonId,
          );

          double startTime = 0.0;
          progressResult.fold(
            (failure) {
              Logger().e('Failed to get progress: ${failure.message}');
              // Continue with startTime = 0.0 if progress fetch fails
            },
            (progressResponse) {
              // Parse current_time string to double
              final currentTimeStr = progressResponse.progress.currentTime;
              startTime = double.tryParse(currentTimeStr) ?? 0.0;
            },
          );

          // Clear loading state before playing video
          if (mounted) {
            setState(() {
              _loadingLessonId = null;
            });
            
            // Play video with file path, storage type, and start time
            if (widget.onLessonTap != null) {
              widget.onLessonTap?.call(filePath, storage, startTime);
            }
          }
        },
      );
    } catch (e, stackTrace) {
      Logger().e('Error handling lesson tap: $e', stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _loadingLessonId = null; // Clear loading state on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while loading the lesson')),
        );
      }
    }
  }

  Widget _buildMeetingsTab() {
    return CourseMeetingsWidget(
      courseId: widget.courseDetail.id.toString(),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review,
            size: 60.w,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'No reviews yet',
            textAlign: TextAlign.center,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Be the first to review this course',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
