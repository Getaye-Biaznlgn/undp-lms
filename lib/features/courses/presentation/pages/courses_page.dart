import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/widgets/course_list_skeleton.dart';
import 'package:lms/features/courses/presentation/bloc/category_bloc.dart';
import 'package:lms/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:lms/features/courses/presentation/widgets/category_filter.dart';
import 'package:lms/features/courses/presentation/widgets/course_list_item.dart';
import 'package:lms/features/courses/presentation/widgets/course_search_widget.dart';
import 'package:lms/features/home/presentation/pages/course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String? selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoriesEvent());
    // Load popular courses by default
    context.read<CoursesBloc>().add(GetPopularCoursesEvent());
  }

 

  void _onCategorySelected(String? categorySlug) {
    setState(() {
      selectedCategory = categorySlug;
    });
    
    if (categorySlug != null) {
      // Fetch courses by category
      context.read<CoursesBloc>().add(GetCoursesByCategoryEvent(slug: categorySlug));
    } else {
      // Load popular courses when no category is selected
      context.read<CoursesBloc>().add(GetPopularCoursesEvent());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        
        elevation: 0,
        title: Text(
          'Courses',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: false,

      ),
      body: Column(
        children: [
          // Search Section
          CourseSearchWidget(
            initialValue: _searchQuery,
            selectedCategory: selectedCategory,
          ),
          // Category Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return SizedBox(
                    height: 40.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                } else if (state is CategoryLoadedState) {
                  return CategoryFilter(
                    categories: state.categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  );
                } else if (state is CategoryErrorState) {
                  return ErrorRetryWidget(
                    title: state.message,
                    onRetry: () {
                      context.read<CategoryBloc>().add(GetCategoriesEvent());
                    },
                    height: 40,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Course List Section
          Expanded(
            child: Container(
              color: AppTheme.backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  if (state is CoursesLoadingState) {
                    return const CourseVerticalListSkeleton(
                      itemCount: 5,
                    );
                  } else if (state is CoursesLoadedState) {
                    return ListView.builder(
                      // padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        final course = state.courses[index];
                        // Highlight the third course (Web UI Best Practices) as shown in the image
                        final isHighlighted = course.slug == 'web-ui-best-practices';
                        
                        return CourseListItem(
                          course: course,
                          isHighlighted: isHighlighted,
                          onTap: () {
                            // Navigate to course detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailPage(
                                  courseSlug: course.slug,
                                ),
                              ),
                            );
                          },
                          onFavoriteToggle: () {
                            // Handle favorite toggle
                            print('Favorite toggled: ${course.title}');
                          },
                        );
                      },
                    );
                  } else if (state is CoursesErrorState) {
                    return ErrorRetryWidget(
                      title: state.message,
                      onRetry: () {
                        if (selectedCategory != null) {
                          context.read<CoursesBloc>().add(GetCoursesByCategoryEvent(slug: selectedCategory!));
                        } else {
                          context.read<CoursesBloc>().add(GetPopularCoursesEvent());
                        }
                      },
                    );
                  }
                  
                  // Default state - show empty state
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No courses available',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
