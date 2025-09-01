import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_model.dart';

class CourseListItem extends StatelessWidget {
  final CourseModel course;
  final bool isHighlighted;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const CourseListItem({
    super.key,
    required this.course,
    this.isHighlighted = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isHighlighted ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Course Image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.white.withOpacity(0.2) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: course.thumbnail.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      '${ApiRoutes.imageUrl}${course.thumbnail}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderIcon();
                      },
                    ),
                  )
                : _buildPlaceholderIcon(),
            ),
            SizedBox(width: 16.w),
            // Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: AppTheme.titleMedium.copyWith(
                      color: isHighlighted ? Colors.white : AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${_getDifficultyLevel()} / ${course.students} lessons',
                    style: AppTheme.bodySmall.copyWith(
                      color: isHighlighted ? Colors.white.withOpacity(0.8) : AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16.w,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        course.averageRating.toString(),
                        style: AppTheme.bodySmall.copyWith(
                          color: isHighlighted ? Colors.white : AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        _getDuration(),
                        style: AppTheme.bodySmall.copyWith(
                          color: isHighlighted ? Colors.white.withOpacity(0.8) : AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite Icon
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Icon(
                Icons.favorite,
                size: 20.w,
                color: isHighlighted ? Colors.red.shade300 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      Icons.school,
      size: 32.w,
      color: Colors.grey.shade400,
    );
  }

  String _getDifficultyLevel() {
    // This could be enhanced based on actual course data
    if (course.students > 40) return 'Advanced';
    if (course.students > 20) return 'Intermediate';
    return 'Beginner';
  }

  String _getDuration() {
    // This could be enhanced based on actual course data
    final hours = (course.averageRating * 1.5).round();
    final minutes = (course.averageRating * 30).round() % 60;
    return '${hours}h ${minutes}min';
  }
}

