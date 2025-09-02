import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';

class CourseVerticalListSkeleton extends StatelessWidget {
  final int itemCount;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CourseVerticalListSkeleton({
    super.key,
    this.itemCount = 5,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _CourseListItemSkeleton(),
          );
        },
      ),
    );
  }
}

class _CourseListItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image Skeleton
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Course Content Skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Skeleton
                  Container(
                    height: 16.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle Skeleton
                  Container(
                    height: 14.h,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Bottom Row Skeleton
                  Row(
                    children: [
                      // Rating Skeleton
                      Container(
                        height: 12.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Duration Skeleton
                      Container(
                        height: 12.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      const Spacer(),
                      // Price Skeleton
                      Container(
                        height: 12.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Favorite Button Skeleton
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer effect wrapper (optional enhancement)
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
