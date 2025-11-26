import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/features/home/presentation/bloc/course_detail_bloc.dart';
import 'package:lms/features/home/presentation/widgets/course_detail_header.dart';
import 'package:lms/features/home/presentation/widgets/course_detail_info.dart';
import 'package:lms/features/home/presentation/widgets/course_detail_tabs.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseSlug;

  const CourseDetailPage({
    super.key,
    required this.courseSlug,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final GlobalKey<CourseDetailHeaderState> _headerKey = GlobalKey<CourseDetailHeaderState>();

  @override
  void initState() {
    super.initState();
    context.read<CourseDetailBloc>().add(GetCourseDetailsEvent(slug: widget.courseSlug));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Course Detail',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          if (state is CourseDetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          } else if (state is CourseDetailLoadedState) {
            return Column(
              children: [
                // Video Header Section (Part of body, not sliver)
                SizedBox(
                  height: 250.h,
                  child: CourseDetailHeader(
                    key: _headerKey,
                    courseDetail: state.courseDetail,
                  ),
                ),
                // Scrollable Content Below Video
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Course Info Section
                        CourseDetailInfo(
                          courseDetail: state.courseDetail,
                        ),
                        // Tabs Section
                        CourseDetailTabs(
                          courseDetail: state.courseDetail,
                          onLessonTap: (videoUrl, storage, startTime) {
                            final headerState = _headerKey.currentState;
                            if (headerState != null) {
                              headerState.playVideo(videoUrl, storage: storage, startTime: startTime);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CourseDetailErrorState) {
            return ErrorRetryWidget(
              title: state.message,
              onRetry: () {
                context.read<CourseDetailBloc>().add(GetCourseDetailsEvent(slug: widget.courseSlug));
              },
            );
          }
          
          return const Center(
            child: Text(
              'No course details available',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          );
        },
      ),
    );
  }
}
