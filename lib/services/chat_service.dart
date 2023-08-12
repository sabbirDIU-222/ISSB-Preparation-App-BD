import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:quizapplication/model/messagemodel.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendMessage(
      String receiverId, String senderId, String senderEmail, String message) async {
    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderId: senderId,
      senderEmail: senderEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Create chat room ID
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  Stream<List<Message>> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList());
  }
}
