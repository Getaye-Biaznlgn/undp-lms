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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isHighlighted ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Course Image
            Container(
              width: size.width * 1/3,
              height: 90.h,
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
                    course.instructor.name,
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
                        '${course.students} students',
                        style: AppTheme.bodySmall.copyWith(
                          color: isHighlighted ? Colors.white.withOpacity(0.8) : AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 8.h),
                  // Row(
                  //   children: [
                  //     if (course.discount > 0) ...[
                  //       Text(
                  //         course.price,
                  //         style: AppTheme.bodySmall.copyWith(
                  //           color: isHighlighted ? Colors.white.withOpacity(0.6) : AppTheme.textSecondaryColor,
                  //           decoration: TextDecoration.lineThrough,
                  //         ),
                  //       ),
                  //       SizedBox(width: 8.w),
                  //       Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  //         decoration: BoxDecoration(
                  //           color: Colors.red,
                  //           borderRadius: BorderRadius.circular(4.r),
                  //         ),
                  //         child: Text(
                  //           '-${course.discount}%',
                  //           style: AppTheme.bodySmall.copyWith(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ] else ...[
                  //       Text(
                  //         course.price,
                  //         style: AppTheme.bodyMedium.copyWith(
                  //           color: isHighlighted ? Colors.white : AppTheme.primaryColor,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ],
                  // ),
                ],
              ),
            ),
            // Favorite Icon
           
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
}

