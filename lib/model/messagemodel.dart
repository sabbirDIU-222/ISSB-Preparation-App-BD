import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return Message(
      // Extract the necessary fields from the document snapshot
      senderId: data?['senderId'] ?? '',
      senderEmail: data?['senderEmail'] ?? '',
      receiverId: data?['receiverId'] ?? '',
      message: data?['message'] ?? '',
      timestamp: data?['timestamp'] ?? Timestamp.now(),
    );
  }
}
