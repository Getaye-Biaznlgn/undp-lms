import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/widgets/course_card.dart';
import 'package:lms/features/home/presentation/bloc/home_bloc.dart';

class PopularLessonsSection extends StatelessWidget {
  const PopularLessonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular lessons',
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
                message: 'Loading popular courses...',
              );
            } else if (context.read<HomeBloc>().popularCourses.isNotEmpty) {
              return CourseCardList(
                courses: context.read<HomeBloc>().popularCourses,
                height: 280,
                onCourseTap: () {
                  // Handle course tap
                },
                onFavoriteToggle: () {
                  // Handle favorite toggle
                },
              );
            } else if (state is HomeErrorState) {
              return ErrorRetryWidget(
                title: 'Failed to load courses',
                description: state.message,
                onRetry: () {
                  context.read<HomeBloc>().add(GetPopularCoursesEvent());
                },
                height: 280,
              );
            }
            
            // Default state - show placeholder cards
            return SizedBox(
              height: 280,
              child: Center(
                child: Text(
                  'No popular courses available',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
