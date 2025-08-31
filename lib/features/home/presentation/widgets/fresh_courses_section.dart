import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/widgets/course_card.dart';
import 'package:lms/features/home/presentation/bloc/home_bloc.dart';

class FreshCoursesSection extends StatelessWidget {
  const FreshCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fresh courses',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            Text(
              'See All',
              style: AppTheme.labelLarge.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const LoadingWidget(
                height: 280,
                message: 'Loading fresh courses...',
              );
            } else if (context.read<HomeBloc>().freshCourses.isNotEmpty) {
              return CourseCardList(
                courses: context.read<HomeBloc>().freshCourses,
                height: 280.h,
                onCourseTap: () {
                  // Handle course tap
                },
                onFavoriteToggle: () {
                  // Handle favorite toggle
                },
              );
            } else if (state is HomeErrorState) {
              return ErrorRetryWidget(
                title: 'Failed to load fresh courses',
                description: state.message,
                onRetry: () {
                  context.read<HomeBloc>().add(GetFreshCoursesEvent());
                },
                height: 280,
              );
            }
            
            // Default state - show placeholder cards
            return Center(
              child: Text('No fresh courses found'),
            );
          },
        ),
      ],
    );
  }
}
