import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';

class CourseDetailTabs extends StatefulWidget {
  final CourseDetailModel courseDetail;

  const CourseDetailTabs({
    super.key,
    required this.courseDetail,
  });

  @override
  State<CourseDetailTabs> createState() => _CourseDetailTabsState();
}

class _CourseDetailTabsState extends State<CourseDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0; // Start with Overview tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _tabController.animateTo(0); // Start with Overview tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelColor: AppTheme.textPrimaryColor,
              unselectedLabelColor: AppTheme.textSecondaryColor,
              labelStyle: AppTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Curriculum'),
                Tab(text: 'Reviews'),
              ],
            ),
          ),
          
          // Tab Content
          Container(
            height: 600.h, // Fixed height to prevent render box errors
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCurriculumTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Description',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          // Parse HTML description and display as rich text
          // For now, showing plain text
          Text(
            widget.courseDetail.description.replaceAll(RegExp(r'<[^>]*>'), ''),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    if (widget.courseDetail.curriculums.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 60.w,
              color: AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'No curriculum available',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.courseDetail.curriculums.length,
      itemBuilder: (context, index) {
        final curriculum = widget.courseDetail.curriculums[index];
        return _buildCurriculumItem(curriculum);
      },
    );
  }

  Widget _buildCurriculumItem(Curriculum curriculum) {
    if (curriculum.chapters.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          curriculum.title,
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      );
    }
    
    return ExpansionTile(
      title: Text(
        curriculum.title,
        style: AppTheme.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      children: curriculum.chapters.map((chapter) {
        return _buildChapterItem(chapter);
      }).toList(),
    );
  }

  Widget _buildChapterItem(Chapter chapter) {
    final isLesson = chapter.type == 'lesson';
    final item = chapter.item;
    
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Icon based on type
          Icon(
            isLesson ? Icons.play_circle_outline : Icons.quiz,
            size: 20.w,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(width: 12.w),
          
          // Title and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isLesson && item.duration != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.duration!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Free indicator or lock
          if (isLesson) ...[
            if (item.isFree == true)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'FREE',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Icon(
                Icons.lock,
                size: 16.w,
                color: AppTheme.textSecondaryColor,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review,
            size: 60.w,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'No reviews yet',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Be the first to review this course',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
