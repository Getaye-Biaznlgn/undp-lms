import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/utils/snackbar_utils.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/core/widgets/common_text_field.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _getCode() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "email": _emailController.text.trim(),
      };
      context.read<AuthBloc>().add(ForgotPasswordEvent(requestData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
                     listener: (context, state) {
                          if (state is AuthSuccessState) {
               // Show success message and navigate to reset password page
               SnackbarUtils.showSuccess(context, 'Password reset code sent to your email');
               context.push('${AppRouter.resetPassword}?email=${_emailController.text.trim()}');
             } else if (state is AuthErrorState) {
               SnackbarUtils.showError(context, state.message);
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
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'Enter your email to receive a reset code',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Email Field
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonTextField(
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    type: TextFieldType.filled,
                    size: TextFieldSize.large,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Get Code Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CommonButton(
                        text: 'Get Code',
                        onPressed: _getCode,
                        type: ButtonType.primary,
                        size: ButtonSize.large,
                        isLoading: state is AuthLoadingState,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
