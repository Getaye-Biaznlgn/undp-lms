import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/chat/domain/models/chat_message.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String currentUserId;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64.w,
              color: AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'No messages yet',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start the conversation!',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(16.w),
      reverse: true, // Align messages to bottom
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // When reverse is true, index 0 is the last message
        final message = messages[messages.length - 1 - index];
        final currentUserIdInt = int.tryParse(currentUserId) ?? 0;
        final isMe = message.senderId == currentUserIdInt;
        return _buildMessageBubble(message, isMe);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Builder(
      builder: (context) => Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
            bottomRight: Radius.circular(isMe ? 4.r : 16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: AppTheme.bodyMedium.copyWith(
                color: isMe ? Colors.white : AppTheme.textPrimaryColor,
                height: 1.4,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _formatTime(message.createdAt),
              style: AppTheme.bodySmall.copyWith(
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : AppTheme.textSecondaryColor,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';
    try {
      final date = DateTime.parse(timeString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timeString;
    }
  }
}



