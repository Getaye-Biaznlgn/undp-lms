import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Color? customColor;
  final Color? customTextColor;
  final double? customWidth;
  final double? customHeight;
  final BorderRadius? customBorderRadius;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.customColor,
    this.customTextColor,
    this.customWidth,
    this.customHeight,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(),
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon??SizedBox.shrink(),
          SizedBox(width: 8.w),
          Text(
            text,
            style: _getTextStyle(),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getTextColor(),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: customBorderRadius ?? BorderRadius.circular(_getBorderRadius()),
        side: _getBorderSide(),
      ),
      elevation: _getElevation(),
      shadowColor: _getShadowColor(),
    );
  }

  Color _getBackgroundColor() {
    if (customColor != null) return customColor!;
    
    switch (type) {
      case ButtonType.primary:
        return AppTheme.primaryColor;
      case ButtonType.secondary:
        return AppTheme.secondaryColor;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (customTextColor != null) return customTextColor!;
    
    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.outline:
        return AppTheme.primaryColor;
      case ButtonType.text:
        return AppTheme.primaryColor;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 16.r;
      case ButtonSize.medium:
        return 24.r;
      case ButtonSize.large:
        return 32.r;
    }
  }

  BorderSide _getBorderSide() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.text:
        return BorderSide.none;
      case ButtonType.outline:
        return BorderSide(color: AppTheme.primaryColor, width: 1.5);
    }
  }

  double _getElevation() {
    switch (type) {
      case ButtonType.primary:
        return 2;
      case ButtonType.secondary:
        return 1;
      case ButtonType.outline:
      case ButtonType.text:
        return 0;
    }
  }

  Color? _getShadowColor() {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.primaryColor.withOpacity(0.3);
      case ButtonType.secondary:
        return AppTheme.secondaryColor.withOpacity(0.3);
      case ButtonType.outline:
      case ButtonType.text:
        return null;
    }
  }

  TextStyle _getTextStyle() {
    double fontSize;
    FontWeight fontWeight;
    
    switch (size) {
      case ButtonSize.small:
        fontSize = 14.sp;
        fontWeight = FontWeight.w500;
        break;
      case ButtonSize.medium:
        fontSize = 16.sp;
        fontWeight = FontWeight.w600;
        break;
      case ButtonSize.large:
        fontSize = 18.sp;
        fontWeight = FontWeight.w600;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _getTextColor(),
    );
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.sp;
      case ButtonSize.medium:
        return 18.sp;
      case ButtonSize.large:
        return 20.sp;
    }
  }

  double? _getWidth() {
    if (customWidth != null) return customWidth;
    if (isFullWidth) return double.infinity;
    return null;
  }

  double? _getHeight() {
    if (customHeight != null) return customHeight;
    return null;
  }
}
