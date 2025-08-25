import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/main/presentation/bloc/main_bloc.dart';
import 'package:lms/features/home/presentation/pages/home_page.dart';
import 'package:lms/features/courses/presentation/pages/courses_page.dart';
import 'package:lms/features/saved/presentation/pages/saved_page.dart';
import 'package:lms/features/profile/presentation/pages/profile_page.dart';

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
            children: const [
              HomePage(),
              CoursesPage(),
              SavedPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<MainBloc>().add(ChangeTab(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
