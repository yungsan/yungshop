import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nguyen_manh_dung/models/message.dart';

class ChatService {
  final _messages = FirebaseFirestore.instance.collection('messages');

  void sendMessage(
      String messageContent, String senderId, String receiverId) async {
    MessageModel messageModel =
        MessageModel(messageContent, senderId, receiverId);
    try {
      await _messages.add(messageModel.toMap());
      print('send message successfully');
    } catch (e) {
      print('send message error: $e');
    }
  }

  getMessagesFromBothUsers(String currentUserId, String receiverId) async {
    return _messages
        .where(Filter.and(
          Filter('sender_id', whereIn: [currentUserId, receiverId]),
          Filter('receiver_id', whereIn: [currentUserId, receiverId]),
        ))
        .orderBy('created_at')
        .snapshots();
  }
}
