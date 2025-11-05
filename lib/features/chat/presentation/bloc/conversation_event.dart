part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversationEvent extends ConversationEvent {
  const LoadConversationEvent();
}

class JoinConversationEvent extends ConversationEvent {
  final String? chatId;
  final String userId;
  final String otherUserId;
  const JoinConversationEvent({
    required this.chatId,
    required this.userId,
    required this.otherUserId,
  });

  @override
  List<Object?> get props => [chatId, userId, otherUserId];
}

class SendMessageEvent extends ConversationEvent {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final String senderType;
  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.senderType,
  });

  @override
  List<Object?> get props => [chatId, senderId, receiverId, message, senderType];
}

class FetchMessagesEvent extends ConversationEvent {
  final String userId;
  final int page;
  final int perPage;
  const FetchMessagesEvent({required this.userId, this.page = 1, this.perPage = 50});

  @override
  List<Object?> get props => [userId, page, perPage];
}

class ReadMessageEvent extends ConversationEvent {
  final String messageId;
  final String userId;
  const ReadMessageEvent({required this.messageId, required this.userId});

  @override
  List<Object?> get props => [messageId, userId];
}

class MessageReceivedEvent extends ConversationEvent {
  final ChatMessage message;
  const MessageReceivedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessagesFetchedEvent extends ConversationEvent {
  final List<ChatMessage> messages;
  const MessagesFetchedEvent({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatJoinedEvent extends ConversationEvent {
  final int serverChatId;
  final List<int> onlineUsers;
  const ChatJoinedEvent({required this.serverChatId, required this.onlineUsers});

  @override
  List<Object?> get props => [serverChatId, onlineUsers];
}


