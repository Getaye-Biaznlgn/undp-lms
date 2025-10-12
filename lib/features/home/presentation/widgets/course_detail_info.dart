import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';

class CourseDetailInfo extends StatelessWidget {
  final CourseDetailModel courseDetail;

  const CourseDetailInfo({
    super.key,
    required this.courseDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Title
          Text(
            courseDetail.title,
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Instructor
          Row(
            children: [
              Text(
                'Created by ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to instructor profile
                },
                child: Text(
                  courseDetail.instructor.name,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Rating and Students
          Row(
            children: [
              // Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < courseDetail.averageRating 
                      ? Icons.star 
                      : Icons.star_border,
                    size: 20.w,
                    color: Colors.amber,
                  );
                }),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${courseDetail.reviewsCount}) | ${courseDetail.students} Students',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Course Statistics
          Row(
            children: [
              // Left Column
              Expanded(
                child: Column(
                  children: [
                    _buildStatItem(
                      icon: Icons.calendar_today,
                      label: 'Last Update',
                      value: courseDetail.lastUpdated,
                    ),
                    SizedBox(height: 12.h),
                    _buildStatItem(
                      icon: Icons.description,
                      label: 'Total Lectures',
                      value: '${courseDetail.lessonsCount}',
                    ),
                  ],
                ),
              ),
              // Right Column
              Expanded(
                child: Column(
                  children: [
                    _buildStatItem(
                      icon: Icons.access_time,
                      label: 'Duration',
                      value: courseDetail.duration,
                    ),
                    SizedBox(height: 12.h),
                    _buildStatItem(
                      icon: Icons.quiz,
                      label: 'Quizzes',
                      value: '${courseDetail.quizzesCount}',
                    ),
                    SizedBox(height: 12.h),
                    _buildStatItem(
                      icon: Icons.verified,
                      label: 'Certificate',
                      value: courseDetail.certificate ? 'Yes' : 'No',
                    ),
                    SizedBox(height: 12.h),
                    _buildStatItem(
                      icon: Icons.language,
                      label: 'Language',
                      value: courseDetail.languages,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 24.h),
          
        
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.w,
          color: AppTheme.textSecondaryColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            '$label : $value',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

