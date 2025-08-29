import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:flutter/material.dart';
import "package:lms/dependency_injection.dart" as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/dependency_injection.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
   await sl<ApiService>().init();
  await AppPreferences().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => sl<AuthBloc>(),
            ),
          ],
          child: MaterialApp.router(
            title: 'UNDP LMS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
