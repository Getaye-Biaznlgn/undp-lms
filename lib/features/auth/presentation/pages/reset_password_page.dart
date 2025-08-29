import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/core/widgets/common_text_field.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "forget_password_token": _tokenController.text.trim(),
        "email": widget.email,
        "password": _passwordController.text,
        "password_confirmation": _confirmPasswordController.text,
      };
      context.read<AuthBloc>().add(ResetPasswordEvent(requestData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              // Show success message and navigate to login
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(AppRouter.login);
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.textPrimaryColor,
                      size: 24.sp,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(height: 40.h),

                  // Title
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'Enter the code sent to your email and set a new password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Email Display (Read-only)

                  // Token Field
                  Text(
                    'Reset Code',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonTextField(
                    hintText: 'Enter the reset code',
                    controller: _tokenController,
                    keyboardType: TextInputType.text,
                    type: TextFieldType.filled,
                    size: TextFieldSize.large,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the reset code';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Password Field
                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonTextField(
                    hintText: 'Enter new password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    type: TextFieldType.filled,
                    size: TextFieldSize.large,
                    onObscureToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Confirm Password Field
                  Text(
                    'Confirm New Password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonTextField(
                    hintText: 'Confirm new password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    type: TextFieldType.filled,
                    size: TextFieldSize.large,
                    onObscureToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Reset Password Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CommonButton(
                        text: 'Reset Password',
                        onPressed: _resetPassword,
                        type: ButtonType.primary,
                        size: ButtonSize.large,
                        isLoading: state is AuthLoadingState,
                      );
                    },
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
