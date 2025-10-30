import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/services/socket_manager.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketManager socketManager;
  ChatBloc({required this.socketManager}) : super(const ChatState.initial()) {
    on<LoadChatEvent>((event, emit) async {
      emit(const ChatState.loading());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(const ChatState.loaded());
    });
  }
}


