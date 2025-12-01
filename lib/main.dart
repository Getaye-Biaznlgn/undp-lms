import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/core/services/offline_storage_service.dart';
import 'package:lms/core/services/download_manager_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:flutter/material.dart';
import "package:lms/dependency_injection.dart" as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/dependency_injection.dart';
import 'package:lms/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms/features/chat/presentation/bloc/chat_users_bloc.dart';
import 'package:lms/features/home/presentation/bloc/home_bloc.dart';
import 'package:lms/features/courses/presentation/bloc/category_bloc.dart';
import 'package:lms/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:lms/features/home/presentation/bloc/course_detail_bloc.dart';
import 'package:lms/features/home/presentation/bloc/quiz_bloc.dart';
import 'package:lms/features/home/presentation/bloc/meeting_bloc.dart';
import 'package:lms/features/saved/presentation/bloc/enrolled_courses_bloc.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';
import 'package:lms/features/main/presentation/bloc/main_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await sl<ApiService>().init();
  await AppPreferences().init();
  
  // Initialize offline storage and download manager
  await OfflineStorageService.init();
  await DownloadManagerService().init();
  
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
            BlocProvider<HomeBloc>(
              create: (context) => sl<HomeBloc>(),
            ),
            BlocProvider<CategoryBloc>(
              create: (context) => sl<CategoryBloc>(),
            ),
            BlocProvider<CoursesBloc>(
              create: (context) => sl<CoursesBloc>(),
            ),
            BlocProvider<CourseDetailBloc>(
              create: (context) => sl<CourseDetailBloc>(),
            ),
            BlocProvider<QuizBloc>(
              create: (context) => sl<QuizBloc>(),
            ),
            BlocProvider<MeetingBloc>(
              create: (context) => sl<MeetingBloc>(),
            ),
            BlocProvider<EnrolledCoursesBloc>(
              create: (context) => sl<EnrolledCoursesBloc>(),
            ),
            BlocProvider<UserProfileBloc>(
              create: (context) => sl<UserProfileBloc>(),
            ),
            BlocProvider<MainBloc>(
              create: (context) => sl<MainBloc>(),
            ),
            BlocProvider<ChatUsersBloc>(
              create: (context) => sl<ChatUsersBloc>(),
            ),
            // Note: ConversationBloc is registered as factory and created per conversation in ChatPage
            // If you need a global instance, you can uncomment the line below
            // BlocProvider<ConversationBloc>(
            //   create: (context) => sl<ConversationBloc>(),
            // ),
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
