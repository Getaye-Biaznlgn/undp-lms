import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/widgets/common_app_bar.dart';
import 'package:lms/features/saved/presentation/bloc/enrolled_courses_bloc.dart';
import 'package:lms/features/saved/presentation/widgets/enrolled_course_item.dart';
import 'package:lms/features/home/presentation/pages/course_detail_page.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch enrolled courses when page builds
    context.read<EnrolledCoursesBloc>().add(const GetEnrolledCoursesEvent());
    
    return Scaffold(
      appBar: const WhiteAppBar(
        title: 'My Courses',
      ),
      body: BlocBuilder<EnrolledCoursesBloc, EnrolledCoursesState>(
        builder: (context, state) {
          if (state is EnrolledCoursesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentColor,
              ),
            );
          } else if (state is EnrolledCoursesErrorState) {
            return Center(
              child: ErrorRetryWidget(
                title: state.message,
                onRetry: () {
                  context.read<EnrolledCoursesBloc>().add(const GetEnrolledCoursesEvent());
                },
              ),
            );
          } else if (state is EnrolledCoursesLoadedState) {
            if (state.courses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: AppTheme.accentColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Enrolled Courses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You haven\'t enrolled in any courses yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EnrolledCoursesBloc>().add(const GetEnrolledCoursesEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return EnrolledCourseItem(
                    course: course,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            courseSlug: course.slug,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: AppTheme.accentColor,
                ),
                SizedBox(height: 16),
                Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your enrolled courses will appear here',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
