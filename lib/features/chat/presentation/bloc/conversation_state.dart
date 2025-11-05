part of 'conversation_bloc.dart';

class ConversationState extends Equatable {
  final bool isLoading;
  final bool isJoining;
  final bool isSending;
  final String? chatId;
  final String? otherUserId;
  final List<ChatMessage> messages;
  final String? error;

  const ConversationState({
    required this.isLoading,
    required this.isJoining,
    required this.isSending,
    this.chatId,
    this.otherUserId,
    required this.messages,
    this.error,
  });

  const ConversationState.initial()
      : isLoading = false,
        isJoining = false,
        isSending = false,
        chatId = null,
        otherUserId = null,
        messages = const [],
        error = null;

  ConversationState copyWith({
    bool? isLoading,
    bool? isJoining,
    bool? isSending,
    String? chatId,
    String? otherUserId,
    List<ChatMessage>? messages,
    String? error,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      isSending: isSending ?? this.isSending,
      chatId: chatId ?? this.chatId,
      otherUserId: otherUserId ?? this.otherUserId,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isJoining, isSending, chatId, otherUserId, messages, error];
}


