import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final Color imageColor;
  final bool isFavorite;
  final String duration;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const CourseCard({
    super.key,
    required this.course,
    required this.imageColor,
    this.isFavorite = false,
    this.duration = '6h 30min',
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  // height: 120.h,
                  decoration: BoxDecoration(
                    color: imageColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child:
                      course.thumbnail.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.h),
                            ),
                            child: Image.network(
                              '${ApiRoutes.imageUrl}${course.thumbnail}',
                              fit: BoxFit.cover,
                              height: 130.h,
                              width: double.infinity,

                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.school,
                                    size: 48.sp,
                                    color: imageColor,
                                  ),
                                );
                              },
                            ),
                          )
                          : Center(
                            child: Icon(
                              Icons.school,
                              size: 48.sp,
                              color: imageColor,
                            ),
                          ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color:
                            isFavorite
                                ? AppTheme.errorColor
                                : AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.instructor.name} (${course.students} students)',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14.sp,
                            color: Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.averageRating.toString(),
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// Convenience widget for course lists
class CourseCardList extends StatelessWidget {
  final List<CourseModel> courses;
  final double height;
  final VoidCallback? onCourseTap;
  final VoidCallback? onFavoriteToggle;

  const CourseCardList({
    super.key,
    required this.courses,
    this.height = 280,
    this.onCourseTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < courses.length - 1 ? 12.w : 0,
            ),
            child: CourseCard(
              course: course,
              imageColor: _getColorForCourse(index),
              isFavorite: false,
              duration: '6h 30min',
              onTap: onCourseTap,
              onFavoriteToggle: onFavoriteToggle,
            ),
          );
        },
      ),
    );
  }

  Color _getColorForCourse(int index) {
    final colors = [
      const Color(0xFF00A651), // Green
      const Color(0xFF0066CC), // Blue
      const Color(0xFFFF6B35), // Orange
      const Color(0xFF6F42C1), // Purple
      const Color(0xFFE83E8C), // Pink
      const Color(0xFFFD7E14), // Orange
    ];
    return colors[index % colors.length];
  }
}
