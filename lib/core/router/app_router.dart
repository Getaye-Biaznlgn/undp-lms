import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/features/main/presentation/pages/main_page.dart';
import 'package:lms/features/auth/presentation/pages/splash_page.dart';
import 'package:lms/features/auth/presentation/pages/onboarding_page.dart';
import 'package:lms/features/auth/presentation/pages/login_page.dart';
import 'package:lms/features/auth/presentation/pages/signup_page.dart';
import 'package:lms/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:lms/features/auth/presentation/pages/reset_password_page.dart';
import 'package:lms/features/home/presentation/pages/course_detail_page.dart';
import 'package:lms/features/home/presentation/pages/meetings_list_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String courseDetail = '/course-detail';
  static const String meetingsList = '/meetings-list';
  static const String initial = '/';

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        redirect: (context, state) => splash,
      ),
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: signup,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: forgotPassword,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: resetPassword,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: ResetPasswordPage(
            email: state.uri.queryParameters['email'] ?? '',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: home,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: courseDetail,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: CourseDetailPage(
            courseSlug: state.uri.queryParameters['slug'] ?? '',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: meetingsList,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MeetingsListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
