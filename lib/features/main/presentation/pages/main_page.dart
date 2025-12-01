import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';
import 'package:lms/features/chat/presentation/bloc/chat_users_bloc.dart';
import 'package:lms/features/downloads/presentation/pages/downloads_page.dart';
import 'package:lms/features/main/presentation/bloc/main_bloc.dart';
import 'package:lms/features/home/presentation/pages/home_page.dart';
import 'package:lms/features/courses/presentation/pages/courses_page.dart';
import 'package:lms/features/saved/presentation/bloc/enrolled_courses_bloc.dart';
import 'package:lms/features/saved/presentation/pages/saved_page.dart';
import 'package:lms/features/chat/presentation/pages/chat_user_page.dart';
import 'package:lms/features/profile/presentation/pages/profile_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainView();
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
              const HomePage(),
              const CoursesPage(),
              // const SavedPage(),
              const DownloadsPage(),
              const ChatUserPage(),
              const ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<MainBloc>().add(ChangeTab(index));
              if(index == 2){
                context.read<EnrolledCoursesBloc>().add(const GetEnrolledCoursesEvent());
              }
    
              if(index == 3){
                context.read<ChatUsersBloc>().add(const LoadChatUsersEvent());
              }
              if(index == 4){
                context.read<UserProfileBloc>().add(const GetUserProfileEvent());
              }
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
                icon: Icon(Icons.chat_bubble_outline, size: 26.sp,),
                activeIcon: Icon(Icons.chat_bubble, size: 26.sp,),
                label: 'Chat',
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
