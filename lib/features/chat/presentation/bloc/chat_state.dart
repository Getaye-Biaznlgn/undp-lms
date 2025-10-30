part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final bool isLoading;
  const ChatState({required this.isLoading});

  const ChatState.initial() : isLoading = false;
  const ChatState.loading() : isLoading = true;
  const ChatState.loaded() : isLoading = false;

  @override
  List<Object?> get props => [isLoading];
}


