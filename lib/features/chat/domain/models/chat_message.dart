class ChatMessage {
  final int id;
  final int chatId; // Changed to int to match API
  final int senderId; // Changed to int to match API
  final int? receiverId; // Can be null or 0
  final String message;
  final String senderType;
  final String? attachmentPath;
  final String? attachmentName;
  final String? attachmentType;
  final bool isRead;
  final String? readAt;
  final String? createdAt;
  final String? updatedAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.receiverId,
    required this.message,
    required this.senderType,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentType,
    this.isRead = false,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      chatId: json['chat_id'] is int
          ? json['chat_id']
          : int.tryParse(json['chat_id'].toString()) ?? 0,
      senderId: json['sender_id'] is int
          ? json['sender_id']
          : int.tryParse(json['sender_id'].toString()) ?? 0,
      receiverId: json['receiver_id'] == null
          ? null
          : (json['receiver_id'] is int
              ? (json['receiver_id'] == 0 ? null : json['receiver_id'])
              : (int.tryParse(json['receiver_id'].toString()) == 0
                  ? null
                  : int.tryParse(json['receiver_id'].toString()))),
      message: json['message']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? '',
      attachmentPath: json['attachment_path']?.toString(),
      attachmentName: json['attachment_name']?.toString(),
      attachmentType: json['attachment_type']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == '1' || json['is_read'] == 1,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'sender_type': senderType,
      'attachment_path': attachmentPath,
      'attachment_name': attachmentName,
      'attachment_type': attachmentType,
      'is_read': isRead ? 1 : 0,
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}


