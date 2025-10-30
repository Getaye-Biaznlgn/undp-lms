part of 'chat_users_bloc.dart';

abstract class ChatUsersEvent extends Equatable {
  const ChatUsersEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatUsersEvent extends ChatUsersEvent {
  const LoadChatUsersEvent();
}

class ChatUsersLoadedEvent extends ChatUsersEvent {
  final List<ChatUser> users;
  const ChatUsersLoadedEvent({required this.users});

  @override
  List<Object?> get props => [users];
}
