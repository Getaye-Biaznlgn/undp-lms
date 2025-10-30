import 'dart:convert';

import 'package:lms/core/constants/api_routes.dart';
import 'package:logger/logger.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum SocketEvent {
  
  request,

}

class SocketManager {
  static SocketManager? _instance;
  late io.Socket socket;

  SocketManager._();

  factory SocketManager() {
    return _instance ??= SocketManager._();
  }

  factory SocketManager.getInstance() {
    _instance ??= SocketManager._();
    return _instance!;
  }

  initSocketConnection(String userId) {
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

      socket.onDisconnect((data) {
        Logger().i("socket disconnected");
      });



      socket.onReconnect((data) {
        Logger().i("socket reconnect");
      });
    
      socket.on(SocketEvent.request.name, (data) {
        try {
          //CALL CHATBLOC TO HANDLE THE REQUEST
        } catch (e, st) {
          Logger().e("request error: $e");
        }
      });
    
      
    } on Exception catch (e, st) {
      Logger().e("initSocketConnection: $e");
    } catch (e, st) {
      Logger().e("getVehicle $e");

    }
  }

  void reconnectPassenger(
      {required String tripId,
      required String passengerId,
      required String driverId}) {
    try {
      socket.emit(
          SocketEvent.request.name,
          jsonEncode({
            "tripId": tripId.toString(),
            "passengerId": passengerId.toString(),
            "driverId": driverId.toString()
          }));

      Logger().e("reconnectDriver emitted ${tripId}/$passengerId,/ $driverId ");
    } catch (e, st) {
      Logger().e("reconnectDriver error: $e");
    }
  }
  
  void closeSocket() {
    socket.disconnect();
    socket.close();
  }
}
