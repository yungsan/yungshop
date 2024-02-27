class MessageModel {
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime createdAt = DateTime.now();
  MessageModel(
    this.content,
    this.senderId,
    this.receiverId,
  );
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'created_at': createdAt,
    };
  }
}
