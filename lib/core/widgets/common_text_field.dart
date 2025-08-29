import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';

enum TextFieldType {
  outlined,
  filled,
  underlined,
}

enum TextFieldSize {
  small,
  medium,
  large,
}

class CommonTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextFieldType type;
  final TextFieldSize size;
  final bool isFullWidth;
  final Color? customBorderColor;
  final Color? customFillColor;
  final Color? customTextColor;
  final Color? customLabelColor;
  final Color? customHintColor;
  final double? customWidth;
  final double? customHeight;
  final BorderRadius? customBorderRadius;
  final EdgeInsets? customPadding;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onObscureToggle;

  const CommonTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.type = TextFieldType.outlined,
    this.size = TextFieldSize.medium,
    this.isFullWidth = true,
    this.customBorderColor,
    this.customFillColor,
    this.customTextColor,
    this.customLabelColor,
    this.customHintColor,
    this.customWidth,
    this.customHeight,
    this.customBorderRadius,
    this.customPadding,
    this.focusNode,
    this.autovalidateMode,
    this.onObscureToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        autovalidateMode: autovalidateMode,
        style: _getTextStyle(),
        decoration: _getInputDecoration(),
      ),
    );
  }

  double? _getWidth() {
    if (!isFullWidth) {
      return customWidth ?? 200.w;
    }
    return customWidth;
  }

  TextStyle _getTextStyle() {
    final baseStyle = AppTheme.getTheme().textTheme.bodyMedium?.copyWith(
          color: customTextColor ?? AppTheme.textPrimaryColor,
        );

    switch (size) {
      case TextFieldSize.small:
        return baseStyle?.copyWith(fontSize: 12.sp) ?? TextStyle(fontSize: 12.sp);
      case TextFieldSize.medium:
        return baseStyle?.copyWith(fontSize: 14.sp) ?? TextStyle(fontSize: 14.sp);
      case TextFieldSize.large:
        return baseStyle?.copyWith(fontSize: 16.sp) ?? TextStyle(fontSize: 16.sp);
    }
  }

  InputDecoration _getInputDecoration() {
    final baseDecoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: _getContentPadding(),
      border: _getBorder(),
      enabledBorder: _getBorder(),
      focusedBorder: _getFocusedBorder(),
      errorBorder: _getErrorBorder(),
      focusedErrorBorder: _getErrorBorder(),
      disabledBorder: _getDisabledBorder(),
      filled: type == TextFieldType.filled,
      fillColor: customFillColor ?? AppTheme.surfaceColor,
      labelStyle: _getLabelStyle(),
      hintStyle: _getHintStyle(),
      errorStyle: _getErrorStyle(),
      counterStyle: _getCounterStyle(),
    );

    return baseDecoration;
  }

  Widget? _buildSuffixIcon() {
    if (onObscureToggle != null) {
      return IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppTheme.textSecondaryColor,
        ),
        onPressed: onObscureToggle,
      );
    }
    return suffixIcon;
  }

  EdgeInsets _getContentPadding() {
    if (customPadding != null) {
      return customPadding!;
    }

    switch (size) {
      case TextFieldSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case TextFieldSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
      case TextFieldSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
    }
  }

  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: customBorderRadius ?? BorderRadius.circular(32.r),
      borderSide: BorderSide(
        color: customBorderColor ?? AppTheme.borderColor,
        width: 1.w,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: customBorderRadius ?? BorderRadius.circular(32.r),
      borderSide: BorderSide(
        color: customBorderColor ?? AppTheme.primaryColor,
        width: 2.w,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: customBorderRadius ?? BorderRadius.circular(32.r),
      borderSide: BorderSide(
        color: AppTheme.errorColor,
        width: 1.w,
      ),
    );
  }

  OutlineInputBorder _getDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: customBorderRadius ?? BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppTheme.borderColor.withOpacity(0.5),
        width: 1.w,
      ),
    );
  }

  TextStyle? _getLabelStyle() {
    final baseStyle = AppTheme.getTheme().textTheme.labelMedium?.copyWith(
          color: customLabelColor ?? AppTheme.textSecondaryColor,
        );

    switch (size) {
      case TextFieldSize.small:
        return baseStyle?.copyWith(fontSize: 11.sp);
      case TextFieldSize.medium:
        return baseStyle?.copyWith(fontSize: 12.sp);
      case TextFieldSize.large:
        return baseStyle?.copyWith(fontSize: 14.sp);
    }
  }

  TextStyle? _getHintStyle() {
    final baseStyle = AppTheme.getTheme().textTheme.bodyMedium?.copyWith(
          color: customHintColor ?? AppTheme.textSecondaryColor,
        );

    switch (size) {
      case TextFieldSize.small:
        return baseStyle?.copyWith(fontSize: 11.sp);
      case TextFieldSize.medium:
        return baseStyle?.copyWith(fontSize: 12.sp);
      case TextFieldSize.large:
        return baseStyle?.copyWith(fontSize: 14.sp);
    }
  }

  TextStyle? _getErrorStyle() {
    final baseStyle = AppTheme.getTheme().textTheme.bodySmall?.copyWith(
          color: AppTheme.errorColor,
        );

    switch (size) {
      case TextFieldSize.small:
        return baseStyle?.copyWith(fontSize: 10.sp);
      case TextFieldSize.medium:
        return baseStyle?.copyWith(fontSize: 11.sp);
      case TextFieldSize.large:
        return baseStyle?.copyWith(fontSize: 12.sp);
    }
  }

  TextStyle? _getCounterStyle() {
    final baseStyle = AppTheme.getTheme().textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondaryColor,
        );

    switch (size) {
      case TextFieldSize.small:
        return baseStyle?.copyWith(fontSize: 10.sp);
      case TextFieldSize.medium:
        return baseStyle?.copyWith(fontSize: 11.sp);
      case TextFieldSize.large:
        return baseStyle?.copyWith(fontSize: 12.sp);
    }
  }
}
