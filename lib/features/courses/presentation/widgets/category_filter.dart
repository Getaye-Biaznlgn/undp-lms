import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/category_model.dart';

class CategoryFilter extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.slug;
          
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () {
                if (isSelected) {
                  onCategorySelected(null); // Deselect
                } else {
                  onCategorySelected(category.slug); // Select
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.r),
                  border: isSelected 
                    ? Border.all(color: AppTheme.primaryColor, width: 1)
                    : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category.icon.isNotEmpty) ...[
                      Image.network(
                        '${ApiRoutes.imageUrl}/${category.icon}',
                        width: 16.w,
                        height: 16.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            size: 16.w,
                            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                          );
                        },
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      category.name,
                      style: AppTheme.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () => onCategorySelected(null),
                        child: Icon(
                          Icons.close,
                          size: 14.w,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
