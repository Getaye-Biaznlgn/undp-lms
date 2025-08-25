import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void push(String route, {Object? extra}) {
    context?.push(route, extra: extra);
  }

  static void pushReplacement(String route, {Object? extra}) {
    context?.pushReplacement(route, extra: extra);
  }

  static void pushAndRemoveUntil(String route, {Object? extra}) {
    context?.go(route, extra: extra);
  }

  static void pop() {
    context?.pop();
  }

  static void go(String route, {Object? extra}) {
    context?.go(route, extra: extra);
  }

  // Convenience methods for specific routes
  static void goToHome() {
    go(AppRouter.home);
  }

  static void pushHome({Object? extra}) {
    push(AppRouter.home, extra: extra);
  }
}
