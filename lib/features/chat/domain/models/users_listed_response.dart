class ChatUser {
  final int id;
  final String name;
  final String role;
  final String? socketId;

  ChatUser({
    required this.id,
    required this.name,
    required this.role,
    this.socketId,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: (json['id'] ?? 0) is int ? (json['id'] ?? 0) : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      socketId: json['socket_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'socket_id': socketId,
    };
  }
}


