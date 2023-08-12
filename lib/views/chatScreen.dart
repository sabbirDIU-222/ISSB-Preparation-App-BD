import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/messagemodel.dart';

class ChatPage extends StatelessWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserId,
  }) : super(key: key);

  String chatFirstName() {
    String receiverName = receiverUserEmail;
    String firstName = receiverName[0].toString();
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final senderId = auth.currentUser?.uid;
    final senderEmail = auth.currentUser?.email;
    Size size = MediaQuery.of(context).size;

    TextEditingController _messageController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              child: Text(
                chatFirstName().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text('$receiverUserEmail'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_room')
                  .doc(getChatRoomId(senderId!, receiverUserId))
                  .collection('message')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Message(
                      senderId: data['senderId'],
                      senderEmail: data['senderEmail'],
                      receiverId: data['receiverId'],
                      message: data['message'],
                      timestamp: data['timestamp'],
                    );
                  }).toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message.senderId == senderId;
                      final alignment = isSender
                          ? Alignment.centerLeft
                          : Alignment.bottomRight;
                      /*  final textAlign =
                          isSender ? TextAlign.right : TextAlign.left;*/
                      return isSender
                          ? Row(
                              mainAxisAlignment: isSender
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width - (size.width / 1.3),
                                ),
                                Flexible(
                                  flex: 72,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    crossAxisAlignment: isSender
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                8.0, 8.0, 5.0, 2.0),
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 9.0, 5.0, 9.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFECF8C7),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            child: Container(
                                              child: Text(
                                                message.message,
                                                style: TextStyle(
                                                  fontSize: 19.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5.0, 8.0, 8.0, 2.0),
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 9.0, 5.0, 9.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                constraints: BoxConstraints(
                                    minWidth: size.width / 4,
                                    maxWidth: size.width -
                                        (size.width - (size.width / 1.3))),
                                child: Container(
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            sendMessage(
                              senderId!,
                              senderEmail!,
                              receiverUserId,
                              message,
                            );
                            _messageController.clear();
                          }
                        },
                        icon: Icon(Icons.send,color: Colors.green,size: 30,),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getChatRoomId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    return ids.join("_");
  }

  void sendMessage(
      String senderId, String senderEmail, String receiverId, String message) {
    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderId: senderId,
      senderEmail: senderEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    FirebaseFirestore.instance
        .collection('chat_room')
        .doc(getChatRoomId(senderId, receiverId))
        .collection('message')
        .add(newMessage.toMap());
  }
}
