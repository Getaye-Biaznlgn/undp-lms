import 'package:flutter/material.dart';
import 'package:lms/core/theme/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPressed;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTheme.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? AppTheme.textPrimaryColor,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? AppTheme.textPrimaryColor,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (onBackPressed != null
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: foregroundColor ?? AppTheme.textPrimaryColor,
              ),
              onPressed: onBackPressed,
            )
          : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Predefined AppBar variants for common use cases
class PrimaryAppBar extends CommonAppBar {
  const PrimaryAppBar({
    super.key,
    required super.title,
    super.actions,
    super.leading,
    super.centerTitle = false,
    super.elevation = 0,
    super.automaticallyImplyLeading = true,
    super.onBackPressed,
  }) : super(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        );
}

class WhiteAppBar extends CommonAppBar {
  const WhiteAppBar({
    super.key,
    required super.title,
    super.actions,
    super.leading,
    super.centerTitle = false,
    super.elevation = 0,
    super.automaticallyImplyLeading = true,
    super.onBackPressed,
  }) : super(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textPrimaryColor,
        );
}

class TransparentAppBar extends CommonAppBar {
  const TransparentAppBar({
    super.key,
    required super.title,
    super.actions,
    super.leading,
    super.centerTitle = false,
    super.elevation = 0,
    super.automaticallyImplyLeading = true,
    super.onBackPressed,
  }) : super(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.textPrimaryColor,
        );
}
