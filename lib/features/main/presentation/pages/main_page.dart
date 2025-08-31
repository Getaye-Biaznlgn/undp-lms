import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/main/presentation/bloc/main_bloc.dart';
import 'package:lms/features/home/presentation/pages/home_page.dart';
import 'package:lms/features/home/presentation/bloc/home_bloc.dart';
import 'package:lms/features/courses/presentation/pages/courses_page.dart';
import 'package:lms/features/saved/presentation/pages/saved_page.dart';
import 'package:lms/features/profile/presentation/pages/profile_page.dart';
import 'package:lms/dependency_injection.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: const MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: [
              BlocProvider(
                create: (context) => sl<HomeBloc>(),
                child: const HomePage(),
              ),
              const CoursesPage(),
              const SavedPage(),
              const ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<MainBloc>().add(ChangeTab(index));
            },
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 26.sp,),
                activeIcon: Icon(Icons.home, size: 26.sp,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined, size: 26.sp,),
                activeIcon: Icon(Icons.school, size: 26.sp,),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline, size: 26.sp,),
                activeIcon: Icon(Icons.bookmark, size: 26.sp,),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 26.sp,),
                activeIcon: Icon(Icons.person, size: 26.sp,),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
