import 'package:flutter/material.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/skeleton_loader.dart';

class RetryButton extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onRetry;
  final IconData? icon;
  final double? height;
  final bool showIcon;

  const RetryButton({
    super.key,
    required this.title,
    this.description,
    required this.onRetry,
    this.icon,
    this.height,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 280,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Icon(
                icon ?? Icons.error_outline,
                size: 48,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  description!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Retry',
                    style: AppTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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

// Convenience widget for common error states
class ErrorRetryWidget extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onRetry;
  final double? height;

  const ErrorRetryWidget({
    super.key,
    required this.title,
    this.description,
    required this.onRetry,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return RetryButton(
      title: title,
      description: description,
      onRetry: onRetry,
      height: height,
      icon: Icons.error_outline,
    );
  }
}

// Convenience widget for loading states
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? height;
  final Color? color;
  final bool useSkeleton;

  const LoadingWidget({
    super.key,
    this.message,
    this.height,
    this.color,
    this.useSkeleton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useSkeleton) {
      return CourseListSkeleton(
        height: height ?? 280,
        itemCount: 3,
        itemWidth: 200,
        itemHeight: 280,
      );
    }
    
    return SizedBox(
      height: height ?? 280,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: color ?? AppTheme.primaryColor,
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
