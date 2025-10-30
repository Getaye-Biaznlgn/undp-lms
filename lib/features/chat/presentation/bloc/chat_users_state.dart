part of 'chat_users_bloc.dart';

abstract class ChatUsersState extends Equatable {
  const ChatUsersState();
  @override
  List<Object?> get props => [];
}

class ChatUsersInitialState extends ChatUsersState {
  const ChatUsersInitialState();
}

class ChatUserLoadingState extends ChatUsersState {
  const ChatUserLoadingState();
}

class ChatUsersLoadedState extends ChatUsersState {
  final List<ChatUser> users;
  const ChatUsersLoadedState({required this.users});

  @override
  List<Object?> get props => [users];
}

class ChatUserErrorState extends ChatUsersState {
  final String message;
  const ChatUserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}


