import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/courses/presentation/bloc/courses_bloc.dart';
import 'dart:async'; // Added for Timer

class CourseSearchWidget extends StatefulWidget {
  final String? initialValue;
  final String hintText;
  final String? selectedCategory;

  const CourseSearchWidget({
    super.key,
    this.initialValue,
    this.hintText = 'Search courses...',
    this.selectedCategory,
  });

  @override
  State<CourseSearchWidget> createState() => _CourseSearchWidgetState();
}

class _CourseSearchWidgetState extends State<CourseSearchWidget> {
  late TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Set new timer for debouncing (300ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _handleSearch(query);
    });
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      // If search is empty, load popular courses or selected category
      if (widget.selectedCategory != null) {
        context.read<CoursesBloc>().add(GetCoursesByCategoryEvent(slug: widget.selectedCategory!));
      } else {
        context.read<CoursesBloc>().add(GetPopularCoursesEvent());
      }
    } else {
      // Perform search
      context.read<CoursesBloc>().add(SearchCoursesEvent(query: query));
    }
  }

  void clearSearch() {
    _searchController.clear();
    _handleSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.textSecondaryColor,
            size: 20.w,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.textSecondaryColor,
                    size: 20.w,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
