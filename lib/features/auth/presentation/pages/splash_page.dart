import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/constants/app_images.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
     String? token = AppPreferences().getToken();
     String? userId = AppPreferences().getUserId();
     if(token != null && userId != null){
      // Fetch user profile if token exists
      context.read<UserProfileBloc>().add(const GetUserProfileEvent());
      context.go(AppRouter.home);
     }else{
      context.go(AppRouter.onboarding);
     }
     
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // UNDP Logo/Icon
                   
                    const SizedBox(height: 32),
                    // App Title
                     Center(
                    child: Image.asset(
                      AppImages.logo,
                      height: 150.sp,
                      // width: 100.sp,
                      fit: BoxFit.cover,
                    ),
                  ),
                 SizedBox(height: 10.h),
                    // Subtitle
                    const Text(
                      'Learning Management System',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
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
