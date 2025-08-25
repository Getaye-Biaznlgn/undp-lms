import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/dependency_injection.dart';
import 'package:flutter/material.dart';
import "package:lms/dependency_injection.dart" as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UNDP LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routerConfig: AppRouter.router,
    );
  }
}
