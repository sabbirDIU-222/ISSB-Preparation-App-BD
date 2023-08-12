import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanningScreen extends StatefulWidget {
  final String imageUrl;

  PlanningScreen({required this.imageUrl});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void submitComment(String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final commentData = {
      'comment': comment,
      'userId': user.uid,
      'timestamp': DateTime.now(),
      'imageUrl': widget.imageUrl, // Include the imageUrl in the comment data
    };

    try {
      await FirebaseFirestore.instance.collection('planning').add(commentData);
      _commentController.clear();
    } catch (e) {
      print('Error submitting comment: $e');
    }
  }

  Future<String?> getUserEmail(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.get('email') as String?;
    } catch (e) {
      print('Error retrieving user email: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Planning'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('planning')
                  .where('imageUrl',
                  isEqualTo: widget.imageUrl) // Filter comments by imageUrl
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No planning yet.'),
                  );
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];

                    final commentText = comment['comment'] as String?;
                    final userId = comment['userId'] as String?;

                    return FutureBuilder<String?>(
                      future: getUserEmail(userId!),
                      builder: (context, snapshot) {
                        final userEmail = snapshot.data;

                        return Align(
                          alignment: Alignment.centerRight,
                          child: ListTile(
                            subtitle: Text(
                              commentText ?? '',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  letterSpacing: 1,
                                  color: Colors.black,
                                  wordSpacing: 1.4),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                userEmail != null
                                    ? userEmail
                                    : userId == user?.uid
                                    ? 'You'
                                    : 'Other User',
                                style: TextStyle(color: Colors.black45,fontSize: 16.0),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Write your comment',
                    filled: true, // Add a background color
                    fillColor: Colors.grey[200], // Set the background color
                    border: OutlineInputBorder( // Add border radius
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: null,
                )

            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                submitComment(_commentController.text.trim());
                _commentController.clear();
              },
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
