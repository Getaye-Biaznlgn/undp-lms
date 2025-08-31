import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.sp),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppTheme.backgroundColor,
                widget.highlightColor ?? Colors.grey.shade300,
                widget.baseColor ?? AppTheme.backgroundColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value * 0.3),
            ),
          ),
        );
      },
    );
  }
}


class CourseCardSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const CourseCardSkeleton({
    super.key,
    this.width = 200,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          // Image skeleton
          SkeletonLoader(
            width: double.infinity,
            height: 130.h,
            borderRadius: 16,
          ),
          // Content skeleton
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: 4,
                ),
                SizedBox(height: 8.h),
                // Subtitle skeleton
                SkeletonLoader(
                  width: double.infinity * 0.7,
                  height: 12.h,
                  borderRadius: 4,
                ),
                SizedBox(height: 12.h),
                // Bottom row skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Duration skeleton
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 14.w,
                          height: 14.h,
                          borderRadius: 7,
                        ),
                        SizedBox(width: 4.w),
                        SkeletonLoader(
                          width: 40.w,
                          height: 12.h,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                    // Rating skeleton
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 14.w,
                          height: 14.h,
                          borderRadius: 7,
                        ),
                        SizedBox(width: 4.w),
                        SkeletonLoader(
                          width: 20.w,
                          height: 12.h,
                          borderRadius: 4,
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
    );
  }
}

// Course list skeleton loader
class CourseListSkeleton extends StatelessWidget {
  final int itemCount;
  final double height;
  final double itemWidth;
  final double itemHeight;

  const CourseListSkeleton({
    super.key,
    this.itemCount = 3,
    this.height = 280,
    this.itemWidth = 200,
    this.itemHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < itemCount - 1 ? 10.w : 0,
            ),
            child: CourseCardSkeleton(
              width: itemWidth,
              height: itemHeight,
            ),
          );
        },
      ),
    );
  }
}

// Text skeleton loader
class TextSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const TextSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// List item skeleton loader
class ListItemSkeleton extends StatelessWidget {
  final double height;
  final bool showAvatar;
  final bool showSubtitle;

  const ListItemSkeleton({
    super.key,
    this.height = 60,
    this.showAvatar = true,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          if (showAvatar) ...[
            SkeletonLoader(
              width: 40.w,
              height: 40.h,
              borderRadius: 20,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLoader(
                  width: double.infinity * 0.8,
                  height: 16.h,
                  borderRadius: 4,
                ),
                if (showSubtitle) ...[
                  SizedBox(height: 8.h),
                  SkeletonLoader(
                    width: double.infinity * 0.6,
                    height: 12.h,
                    borderRadius: 4,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Grid skeleton loader
class GridSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;
  final int itemCount;

  const GridSkeleton({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.spacing = 16,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing.w,
        mainAxisSpacing: spacing.h,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return SkeletonLoader(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 8,
        );
      },
    );
  }
}
