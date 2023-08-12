import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapplication/widget/new_PPDT/view_correct_story.dart';

import 'comment_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageSetDetailScreen extends StatefulWidget {
  final String imageUrl;

  ImageSetDetailScreen({required this.imageUrl});

  @override
  State<ImageSetDetailScreen> createState() => _ImageSetDetailScreenState();
}

class _ImageSetDetailScreenState extends State<ImageSetDetailScreen> {
  final TextEditingController _userStoryController = TextEditingController();
  final TextEditingController _adminStoryController = TextEditingController();

  String? correctStory;
  bool isUserSubmitted = false;
  bool isAdmin = false;



  @override
  void initState() {
    super.initState();
    fetchAdminStory();
    final user = FirebaseAuth.instance.currentUser;
    isAdmin = user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }


  void fetchAdminStory() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .where('imageUrl', isEqualTo: widget.imageUrl)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final adminStory = querySnapshot.docs[0].data();

      if (adminStory != null && adminStory['correctStory'] == true) {
        setState(() {
          correctStory = adminStory['story'];
        });
      }
    }

    print('Admin Story: $correctStory');
  }



  void submitUserStory(String story) {
    setState(() {
      isUserSubmitted = true;
    });

    // Check if the user's story is not empty or null
    if (story.trim().isNotEmpty) {
      // Navigate to the next screen with user's story data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewCorrectAnswerScreen(
            imageUrl: widget.imageUrl,
            userStory: story,
            adminStory: correctStory,
          ),
        ),
      );
    } else {
      // Show a dialog to inform the user to write their story
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please write your story before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    _userStoryController.clear();
  }


  void submitAdminStory(String story) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.uid != 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2') {
      // Only admin users can submit correct stories
      return;
    }

    final adminStoryData = {
      'story': story,
      'imageUrl': widget.imageUrl, // Use widget.imageUrl directly if it already contains a valid document ID
      'correctStory': true,
    };

    try {
      // Create a new document with a unique auto-generated ID in the "admin" collection
      await FirebaseFirestore.instance.collection('admin').add(adminStoryData);
      setState(() {
        isUserSubmitted = true;
        correctStory = story;
      });

      // Print the correct story to check if it's set properly
      print('Admin Story: $correctStory');
    } catch (e) {
      print('Error submitting admin story: $e');
    }
    _adminStoryController.clear();
  }




  void navigateToCommentScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(imageUrl: widget.imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Story'),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              navigateToCommentScreen(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submit Correct Story',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _adminStoryController,
                      decoration: InputDecoration(
                        labelText: 'Write the correct story',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      maxLines: null,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        submitAdminStory(_adminStoryController.text.trim());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            'Submit Correct Story',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Story',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _userStoryController,
                    decoration: InputDecoration(
                      labelText: 'Write your story',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      submitUserStory(_userStoryController.text.trim());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            if (isUserSubmitted && isAdmin)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correct Story',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(correctStory ?? ''),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


