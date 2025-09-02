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
  @override
  void initState() {
    super.initState();
    context.read<CourseDetailBloc>().add(GetCourseDetailsEvent(slug: widget.courseSlug));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          if (state is CourseDetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          } else if (state is CourseDetailLoadedState) {
            return CustomScrollView(
              slivers: [
                // Fixed Video Header Section
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250.h,
                    child: Stack(
                      children: [
                        // Video Header
                        CourseDetailHeader(
                          courseDetail: state.courseDetail,
                        ),
                        // App Bar overlay
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8.h,
                              left: 8.w,
                              right: 8.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                IconButton(
                                  icon: Icon(
                                    state.courseDetail.isWishlist 
                                      ? Icons.favorite 
                                      : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // TODO: Implement wishlist toggle
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Course Info Section
                SliverToBoxAdapter(
                  child: CourseDetailInfo(
                    courseDetail: state.courseDetail,
                  ),
                ),
                // Tabs Section
                SliverToBoxAdapter(
                  child: CourseDetailTabs(
                    courseDetail: state.courseDetail,
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
