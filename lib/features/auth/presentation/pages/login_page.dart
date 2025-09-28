import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/constants/app_images.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/utils/snackbar_utils.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/core/widgets/common_text_field.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      };
      context.read<AuthBloc>().add(LoginEvent(requestData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF8F9FF), // Light purple background
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              // Fetch user profile after successful login
              context.read<UserProfileBloc>().add(const GetUserProfileEvent());
              // Navigate to home on successful login
              context.go(AppRouter.home);
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
                  SizedBox(height: 10.h),
                  // App Logo
                  Center(
                    child: Image.asset(
                      AppImages.logo,
                      height: 120.sp,
                      // width: 100.sp,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Title
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'Login to continue using the app',
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

                  SizedBox(height: 24.h),

                  // Password Field
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonTextField(
                    hintText: 'Enter password',
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
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 8.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                                             onPressed: () {
                         context.push(AppRouter.forgotPassword);
                       },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                                     // Login Button
                   BlocBuilder<AuthBloc, AuthState>(
                     builder: (context, state) {
                       return CommonButton(
                         text: 'Login',
                         onPressed: _login,
                         type: ButtonType.primary,
                         size: ButtonSize.large,
                         isLoading: state is AuthLoadingState,
                       );
                     },
                   ),

                  SizedBox(height: 32.h),

                  // Or Login with
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.borderColor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Or Login with',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppTheme.borderColor)),
                    ],
                  ),

                  SizedBox(height: 24.h),

                                     // Social Login Buttons
                   Row(
                     children: [
                       Expanded(
                         child: CommonButton(
                           text: 'Continue with Google',
                           onPressed: () {
                             // TODO: Google login
                           },
                           type: ButtonType.outline,
                           size: ButtonSize.medium,
                           
                           icon: Image.asset(AppImages.googleIcon, height: 25.h, width: 25.w,),
                         ),
                       ),
                     ],
                   ),
                 

                  SizedBox(height: 40.h),

                  // Register Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14.sp,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                                                             onTap: () {
                                 context.push(AppRouter.signup);
                               },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
