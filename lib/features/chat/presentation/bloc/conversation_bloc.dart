import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/services/socket_manager.dart';
import 'package:lms/features/chat/domain/models/chat_message.dart';
import 'package:logger/logger.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SocketManager socketManager;
  final String currentUserId;

  ConversationBloc({required this.socketManager, required this.currentUserId})
      : super(const ConversationState.initial()) {
        //Emit events
    on<JoinConversationEvent>(_onJoin);
    on<SendMessageEvent>(_onSend);
    on<FetchMessagesEvent>(_onFetch);
    on<ReadMessageEvent>(_onRead);
    //listen to message received
    on<MessageReceivedEvent>(_onMessageReceived);
    on<MessagesFetchedEvent>(_onMessagesFetched);
    on<ChatJoinedEvent>(_onChatJoined);
  }

  Future<void> _onJoin(
    JoinConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    // Store otherUserId in state for fetching messages later
    final chatIdInt = event.chatId != null ? int.tryParse(event.chatId!) : null;
    
    emit(state.copyWith(
      isJoining: true,
      chatId: event.chatId,
      otherUserId: event.otherUserId,
    ));
    
    // If chat_id is provided (static), register conversation immediately
    if (chatIdInt != null) {
      // Register conversation for message dispatching using static chat_id
      socketManager.registerConversation(
        chatIdInt,
        (messages) {
          add(MessagesFetchedEvent(messages: messages));
        },
      );
      
      // Update state and mark joining as complete
      emit(state.copyWith(
        isJoining: false,
        chatId: event.chatId,
      ));
      
      // Automatically fetch messages after registering conversation
      if (event.otherUserId.isNotEmpty) {
        add(FetchMessagesEvent(userId: event.otherUserId));
      }
    } else {
      // If no chat_id provided, wait for server response
      // Register pending join to receive server chat_id
      socketManager.registerPendingJoin(
        currentUserId, // Logged-in user for authentication/matching
        event.otherUserId, // The user we're chatting with
        (serverChatId, onlineUsers) {
          add(ChatJoinedEvent(serverChatId: serverChatId, onlineUsers: onlineUsers));
        },
      );
      
      socketManager.joinChat(
        chatId: event.chatId,
        userId: event.userId, // Logged-in user ID
      );
      // Don't set isJoining to false yet - wait for joined_chat response
    }
  }
  
  void _onChatJoined(
    ChatJoinedEvent event,
    Emitter<ConversationState> emit,
  ) {
    // Register conversation for message dispatching using server chat_id
    socketManager.registerConversation(
      event.serverChatId,
      (messages) {
        add(MessagesFetchedEvent(messages: messages));
      },
    );
    
    // Update state with server chat_id and mark joining as complete
    emit(state.copyWith(
      isJoining: false,
      chatId: event.serverChatId.toString(), // Store server chat_id
    ));
    
    // Automatically fetch messages after joining and registering conversation
    // Use otherUserId (the user we're chatting with) for fetching messages
    if (state.otherUserId != null) {
      add(FetchMessagesEvent(userId: state.otherUserId!));
    }
  }

  Future<void> _onSend(
    SendMessageEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(state.copyWith(isSending: true));
    socketManager.sendMessage(
      chatId: event.chatId,
      senderId: event.senderId,
      receiverId: event.receiverId,
      message: event.message,
      senderType: event.senderType,
    );
    emit(state.copyWith(isSending: false));
  }

  Future<void> _onFetch(
    FetchMessagesEvent event,
    Emitter<ConversationState> emit,
  ) async {
    Logger().i("onFetch: ${event.userId}, chatId: ${state.chatId}");
    emit(state.copyWith(isLoading: true));
    socketManager.fetchMessages(
      userId: event.userId,
      page: event.page,
      perPage: event.perPage,
    );
    // Don't set isLoading to false yet - wait for messages_fetched response
  }

  Future<void> _onRead(
    ReadMessageEvent event,
    Emitter<ConversationState> emit,
  ) async {
    socketManager.readMessage(
      messageId: event.messageId,
      userId: event.userId,
    );
  }

  void _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ConversationState> emit,
  ) {
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(event.message);
    emit(state.copyWith(messages: updatedMessages));
  }

  void _onMessagesFetched(
    MessagesFetchedEvent event,
    Emitter<ConversationState> emit,
  ) {
    emit(state.copyWith(messages: event.messages, isLoading: false));
  }
}


