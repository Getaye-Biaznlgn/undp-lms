import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/dependency_injection.dart';
import 'package:lms/features/chat/domain/models/users_listed_response.dart';
import 'package:lms/features/chat/presentation/bloc/conversation_bloc.dart';
import 'package:lms/features/chat/presentation/widgets/message_input.dart';
import 'package:lms/features/chat/presentation/widgets/message_list.dart';

class ChatPage extends StatefulWidget {
  final ChatUser otherUser;

  const ChatPage({
    super.key,
    required this.otherUser,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ConversationBloc _conversationBloc;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = AppPreferences().getUserId() ?? '';

    // Create ConversationBloc using dependency injection factory
    _conversationBloc = sl<ConversationBloc>();

    // Join chat first to get chat_id from server
    // Messages will be fetched automatically after joining (in _onChatJoined)
    _conversationBloc.add(JoinConversationEvent(
      chatId: '23', // Static chat_id for testing
      userId: _currentUserId,
      otherUserId: widget.otherUser.id.toString(),
    ));
  }
  
  void _scrollToBottom() {
    // When reverse is true, position 0 is at the bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // Unregister conversation from SocketManager using chat_id
    final chatId = _conversationBloc.state.chatId;
    if (chatId != null) {
      final chatIdInt = int.tryParse(chatId);
      if (chatIdInt != null) {
        _conversationBloc.socketManager.unregisterConversation(chatIdInt);
      }
    }
    
    _messageController.dispose();
    _scrollController.dispose();
    _conversationBloc.close();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Get chat_id from state (set by server after joining)
    final chatId = _conversationBloc.state.chatId;
    if (chatId == null) {
      // Chat not joined yet, can't send message
      return;
    }

    _conversationBloc.add(
      SendMessageEvent(
        chatId: chatId,
        senderId: _currentUserId,
        receiverId: widget.otherUser.id.toString(),
        message: message,
        senderType: 'user',
      ),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _conversationBloc,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(Icons.person, color: Colors.white, size: 20.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.otherUser.name,
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.otherUser.role,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ConversationBloc, ConversationState>(
                listener: (context, state) {
                  // Auto-scroll to bottom when new messages arrive
                  if (state.messages.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                },
                builder: (context, state) {
                  if (state.isJoining) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    );
                  }

                  return MessageList(
                    messages: state.messages,
                    currentUserId: _currentUserId,
                    scrollController: _scrollController,
                  );
                },
              ),
            ),
            BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                return MessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                  isSending: state.isSending,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

