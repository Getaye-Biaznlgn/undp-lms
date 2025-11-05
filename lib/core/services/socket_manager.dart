import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/dependency_injection.dart';
import 'package:lms/features/chat/domain/models/users_listed_response.dart';
import 'package:lms/features/chat/domain/models/chat_message.dart';
import 'package:lms/features/chat/presentation/bloc/chat_users_bloc.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum SocketEvent {
  // LISTEN_TO_EVENTS,
  authenticated,
  joined_chat,
  error_event,
  message_status,
  message_received,
  message_sent,
  messages_fetched,
  users_listed,
  message_road_confirm,

  // EMIT_EVENTS,
  authenticate,
  send_message,
  fetch_messages,
  join_chat,
  list_users,
  read_message,
}

class SocketManager {
  static SocketManager? _instance;
  late io.Socket socket;
  String? authenticatedSocketId;
  
  SocketManager._();

  factory SocketManager() {
    return _instance ??= SocketManager._();
  }

  factory SocketManager.getInstance() {
    _instance ??= SocketManager._();
    return _instance!;
  }

  initSocketConnection() {
    try {
      socket = io.io(
        ApiRoutes.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            // .setExtraHeaders({'passenger-token': token})
            .build(),
      );

      socket.connect();
      socket.onConnect((data) {
        Logger().i("socket connected: ${AppPreferences().getUserId()}");
        authenticate(userId: AppPreferences().getUserId() ?? '');
      });

      socket.onDisconnect((data) {
        Logger().i("socket disconnected");
      });

      socket.onReconnect((data) {
        Logger().i("socket reconnect");
      });

      socket.on(SocketEvent.authenticated.name, (data) {
        try {
          if (data is Map) {
            Logger().i("socket authenticated: $data");
            authenticatedSocketId = data['socket_id']?.toString();
          }
        } catch (e) {
          Logger().e('parse authenticated event error: $e');
        }
      });

      socket.on(SocketEvent.joined_chat.name, (data) {
        try {
          Logger().i("socket joined_chat event received: $data");
          if (data is Map && data['ok'] == true) {
            final serverChatId = data['chat_id'];
            final onlineUsers = data['online_users'];
            
            Logger().i("Processing joined_chat - chat_id: $serverChatId, online_users: $onlineUsers");
            
            if (serverChatId != null && onlineUsers is List) {
              final List<int> onlineUsersList = onlineUsers
                  .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
                  .where((e) => e > 0)
                  .toList();
              
              Logger().i("Pending joins count: ${_pendingJoins.length}");
              
              // Find and register the conversation
              _handleJoinedChatResponse(
                serverChatId: serverChatId is int ? serverChatId : int.tryParse(serverChatId.toString()) ?? 0,
                onlineUsers: onlineUsersList,
              );
            } else {
              Logger().w("Invalid joined_chat response - missing chat_id or online_users");
            }
          } else {
            Logger().w("joined_chat response ok is false or missing");
          }
        } catch (e, st) {
          Logger().e("socket joined chat error: $e", stackTrace: st);
        }
      });

      socket.on(SocketEvent.error_event.name, (data) {
        Logger().e("socket error event: $data");
      });

      socket.on(SocketEvent.message_status.name, (data) {
        Logger().i("socket message status: $data");
      });

      socket.on(SocketEvent.message_received.name, (data) {
        Logger().i("socket message received: $data");
      });

      socket.on(SocketEvent.message_sent.name, (data) {
        Logger().i("socket message sent: $data");
      });

      socket.on(SocketEvent.messages_fetched.name, (data) {
        try {
          Logger().i("socket message_fetched: $data");
          if (data is Map && data['grouped'] != null) {
            final grouped = data['grouped'] as Map<String, dynamic>;
            final List<ChatMessage> allMessages = [];
            
            // Extract all messages from grouped object
            grouped.forEach((key, value) {
              if (value is List) {
                for (var msgJson in value) {
                  if (msgJson is Map<String, dynamic>) {
                    try {
                      final message = ChatMessage.fromJson(msgJson);
                      allMessages.add(message);
                    } catch (e) {
                      Logger().e("Error parsing message: $e");
                    }
                  }
                }
              }
            });
            
            Logger().i("Parsed ${allMessages.length} messages from grouped response");
            
            // Dispatch messages to active conversations
            final currentUserId = AppPreferences().getUserId() ?? '';
            if (currentUserId.isNotEmpty) {
              _dispatchMessagesToConversations(allMessages, currentUserId);
            }
          }
        } catch (e, st) {
          Logger().e("socket message fetched error: $e", stackTrace: st);
        }
      });

      socket.on(SocketEvent.users_listed.name, (data) {
        try {
          final map = (data as Map);
          final List<dynamic> raw = (map['users'] as List<dynamic>? ?? []);
          final List<ChatUser> users = raw
              .map((e) => ChatUser.fromJson(e as Map<String, dynamic>))
              .toList();
          Logger().i("socket users listed: count=${users.length}");
          sl<ChatUsersBloc>().add(ChatUsersLoadedEvent(users: users));
        } catch (e, st) {
          Logger().e("socket users listed error: $e", stackTrace: st);
        }
      });

      socket.on(SocketEvent.message_road_confirm.name, (data) {
        Logger().i("socket message road confirm: $data");
      });
    } on Exception catch (e) {
      Logger().e("initSocketConnection: $e");
    } catch (e) {
      Logger().e("getVehicle $e");
    }
  }

  void authenticate({required String userId}) {
    final payload = {'user_id': userId};
    socket.emit(SocketEvent.authenticate.name, payload);
  }

  void sendMessage({
    required String? chatId,
    required String senderId,
    required String receiverId,
    required String message,
    required String senderType,
  }) {
    final payload = {
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'sender_type': senderType,
    };
    socket.emit(SocketEvent.send_message.name, payload);
  }

  void fetchMessages({
    required String userId,
    required int page,
    required int perPage,
  }) {
    final payload = {'user_id': userId, 'page': page, 'per_page': perPage};
    socket.emit(SocketEvent.fetch_messages.name, payload);
     Logger().i("onFetch: ${userId}");
  }

  void joinChat({
    required String? chatId,
    required String userId,

  }) {
    final payload = {
      'chat_id': chatId,
      'user_id': userId,
      'socket_id':  authenticatedSocketId,
    };
    Logger().i("Joining chat - chat_id: $chatId, user_id: $userId, socket_id: $authenticatedSocketId");
    socket.emit(SocketEvent.join_chat.name, payload);
  }

  void listUsers() {
    socket.emit(SocketEvent.list_users.name);
    Logger().e("GET socket list users");
  }

  void readMessage({required String messageId, required String userId}) {
    final payload = {'message_id': messageId, 'user_id': userId};
    socket.emit(SocketEvent.read_message.name, payload);
  }

  // Store active conversation blocs by chat_id (server-provided)
  final Map<int, Function(List<ChatMessage>)> _activeConversations = {};
  
  // Store pending join requests: participant key -> callback(serverChatId, onlineUsers)
  final Map<String, Function(int, List<int>)> _pendingJoins = {};
  
  // Register an active conversation for message dispatching using chat_id
  void registerConversation(int chatId, Function(List<ChatMessage>) onMessages) {
    _activeConversations[chatId] = onMessages;
    Logger().i("Registered conversation for chat_id: $chatId");
  }
  
  // Register a pending join request
  void registerPendingJoin(String currentUserId, String otherUserId, Function(int, List<int>) onJoined) {
    final key = _getConversationKey(currentUserId, otherUserId);
    _pendingJoins[key] = onJoined;
    Logger().i("Registered pending join: $key");
  }
  
  // Unregister a conversation by chat_id
  void unregisterConversation(int chatId) {
    _activeConversations.remove(chatId);
    Logger().i("Unregistered conversation for chat_id: $chatId");
  }
  
  // Handle joined_chat response
  void _handleJoinedChatResponse({required int serverChatId, required List<int> onlineUsers}) {
    Logger().i("Handling joined_chat response - serverChatId: $serverChatId, onlineUsers: $onlineUsers, pendingJoins: ${_pendingJoins.length}");
    
    // Find the pending join by matching online users
    // The online_users list should contain both users in the conversation
    bool found = false;
    for (var entry in _pendingJoins.entries) {
      final parts = entry.key.split('-');
      if (parts.length == 2) {
        final id1 = int.tryParse(parts[0]) ?? 0;
        final id2 = int.tryParse(parts[1]) ?? 0;
        
        Logger().i("Checking pending join key: ${entry.key} (id1: $id1, id2: $id2)");
        
        // Check if both users are in online_users
        final hasUser1 = onlineUsers.contains(id1);
        final hasUser2 = onlineUsers.contains(id2);
        
        Logger().i("  - hasUser1: $hasUser1, hasUser2: $hasUser2");
        
        if (hasUser1 && hasUser2) {
          // This is the matching conversation
          final callback = entry.value;
          Logger().i("✓ Matched pending join for key: ${entry.key}, server_chat_id: $serverChatId");
          callback(serverChatId, onlineUsers);
          found = true;
          
          // Optionally remove from pending joins (or keep it for future reference)
          // _pendingJoins.remove(entry.key);
          break;
        }
      }
    }
    
    if (!found) {
      Logger().w("⚠ No matching pending join found for serverChatId: $serverChatId, onlineUsers: $onlineUsers");
    }
  }
  
  // Get conversation key from two user IDs (sorted)
  String _getConversationKey(String userId1, String userId2) {
    final id1 = int.tryParse(userId1) ?? 0;
    final id2 = int.tryParse(userId2) ?? 0;
    return id1 < id2 ? '$id1-$id2' : '$id2-$id1';
  }
  
  // Dispatch messages to active conversations based on chat_id
  void _dispatchMessagesToConversations(List<ChatMessage> allMessages, String currentUserId) {
    // Group messages by chat_id
    final Map<int, List<ChatMessage>> conversationMessages = {};
    
    for (var message in allMessages) {
      final chatId = message.chatId;
      conversationMessages.putIfAbsent(chatId, () => []).add(message);
    }
    
    // Dispatch messages to registered conversations by chat_id
    conversationMessages.forEach((chatId, messages) {
      final callback = _activeConversations[chatId];
      if (callback != null) {
        // Sort messages by created_at (oldest first)
        messages.sort((a, b) {
          final aTime = a.createdAt ?? '';
          final bTime = b.createdAt ?? '';
          return aTime.compareTo(bTime);
        });
        callback(messages);
        Logger().i("Dispatched ${messages.length} messages to chat_id: $chatId");
      } else {
        Logger().w("No registered conversation found for chat_id: $chatId (have ${messages.length} messages)");
      }
    });
  }

  void closeSocket() {
    socket.disconnect();
    socket.close();
  }
}
