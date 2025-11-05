import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/chat/presentation/bloc/chat_users_bloc.dart';
import 'package:lms/features/chat/presentation/pages/chat_page.dart';

class ChatUserPage extends StatelessWidget {
  const ChatUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chats',
                  style: AppTheme.titleLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: BlocBuilder<ChatUsersBloc, ChatUsersState>(
                    builder: (context, state) {
                      if (state is ChatUserLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppTheme.primaryColor),
                        );
                      } else if (state is ChatUsersLoadedState) {
                        if (state.users.isEmpty) {
                          return _emptyUsers();
                        }
                        return ListView.separated(
                          itemCount: state.users.length,
                          separatorBuilder: (_, __) => Divider(color: AppTheme.dividerColor),
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            final online = (user.socketId != null && user.socketId!.isNotEmpty);
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                              leading: CircleAvatar(
                                radius: 22.w,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                child: Icon(Icons.person, color: AppTheme.primaryColor),
                              ),
                              title: Text(user.name, style: AppTheme.titleSmall),
                              subtitle: Text(user.role, style: AppTheme.bodySmall),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                      color: online ? Colors.green : AppTheme.textTertiaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () {
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(otherUser: user),
                                  ),
                                );
                                // Navigate to conversation screen later
                              },
                            );
                          },
                        );
                      } else if (state is ChatUserErrorState) {
                        return Center(
                          child: Text(state.message, style: AppTheme.bodyMedium),
                        );
                      }
                      return _emptyUsers();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    // );
  }

  Widget _emptyUsers() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64.w, color: AppTheme.textSecondaryColor),
          SizedBox(height: 12.h),
          Text('No users available', style: AppTheme.titleSmall.copyWith(color: AppTheme.textSecondaryColor)),
        ],
      ),
    );
  }
}
