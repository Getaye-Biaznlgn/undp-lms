import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lms/core/services/socket_manager.dart';
import 'package:lms/features/chat/domain/models/users_listed_response.dart';

part 'chat_users_event.dart';
part 'chat_users_state.dart';

class ChatUsersBloc extends Bloc<ChatUsersEvent, ChatUsersState> {
  final SocketManager socketManager;
  List<ChatUser> users = [];
  ChatUsersBloc({required this.socketManager}) : super(const ChatUsersInitialState()) {
    on<LoadChatUsersEvent>(_onLoadUsers);
    on<ChatUsersLoadedEvent>(_onChatUsersLoaded);
  }

  void _onLoadUsers(
    LoadChatUsersEvent event,
    Emitter<ChatUsersState> emit,
  ) {
    emit(const ChatUserLoadingState());
    try {
      socketManager.listUsers();
    } catch (e) {
      emit(const ChatUserErrorState(message: 'Failed to load users'));
    }
  }

  void _onChatUsersLoaded(
    ChatUsersLoadedEvent event,
    Emitter<ChatUsersState> emit,
  ) {
    emit(ChatUsersLoadedState(users: event.users));
  }
}


