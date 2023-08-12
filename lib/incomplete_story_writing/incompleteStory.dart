import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'incompleteStoryDetail.dart';

class IncompleteStoryScreen extends StatefulWidget {
  @override
  _IncompleteStoryScreenState createState() => _IncompleteStoryScreenState();
}

class _IncompleteStoryScreenState extends State<IncompleteStoryScreen> {
  late User? user;
  List<DocumentSnapshot> questionSets = [];

  @override
  void initState() {
    super.initState();
    _fetchIncompleteStories();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchIncompleteStories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('incomplete_story').get();

    setState(() {
      questionSets = snapshot.docs;
    });
  }

  Future<void> deleteStory(String storyId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('incomplete_story').doc(storyId).delete();

    // Refresh the story list after deleting
    _fetchIncompleteStories();
  }

  bool isAdmin() {
    return user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  void createNewDocument() async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('incomplete_story');

    // Create a new document with empty data
    final newDocumentRef = await collectionRef.add({});

    // Get the ID of the newly created document
    final newDocumentId = newDocumentRef.id;

    // Navigate to the edit screen for the new document
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDocumentScreen(documentId: newDocumentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Incomplete Stories',),

        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: questionSets.length,
        itemBuilder: (context, index) {
          final questionSet = questionSets[index];
          final setId = questionSet.id;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Card(
                color: Color(0xFFE6E6FA),
                child: ListTile(
                  leading: Icon(
                    Icons.abc_rounded,
                    color: Color(0xFF536878),
                    size: 45,
                  ),
                  title: Text(
                    'Quesion  ${index + 1}',
                    style: TextStyle(fontSize: 18.0,fontFamily: 'Sirin',letterSpacing: 2),
                    textAlign: TextAlign.center,
                  ),
                  trailing: isAdmin()
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Set'),
                                content: Text(
                                    'Are you sure you want to delete this set?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteStory(setId);
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : null,
                  onTap: () {
                    // Handle the selection of a question set here
                    // You can navigate to the WAT screen passing the selected setId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncompleteStoryDetailsScreen(setId),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: isAdmin()
          ? FloatingActionButton(
              onPressed: () {
                // Create a new document in Firebase and navigate to the edit screen
                createNewDocument();
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

class EditDocumentScreen extends StatefulWidget {
  final String documentId;

  const EditDocumentScreen({required this.documentId});

  @override
  _EditDocumentScreenState createState() => _EditDocumentScreenState();
}

class _EditDocumentScreenState extends State<EditDocumentScreen> {
  TextEditingController wordController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();

  @override
  void dispose() {
    wordController.dispose();
    correctAnswerController.dispose();
    super.dispose();
  }

  void saveDocument() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef =
        firestore.collection('incomplete_story').doc(widget.documentId);

    // Get the existing story lines stored in the document
    final snapshot = await documentRef.get();
    List<String> storyLines = [];
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      storyLines = List<String>.from(data['storyLines'] ?? []);
    }

    // Add the new story lines to the list
    storyLines.addAll(wordController.text.split('\n'));

    // Update the document with the updated list of story lines
    await documentRef.set({
      'storyLines': storyLines,
    }, SetOptions(merge: true));

    wordController.clear(); // Clear the text field
  }

  void submitDocument() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef =
        firestore.collection('incomplete_story').doc(widget.documentId);

    // Get the existing story lines stored in the document
    final snapshot = await documentRef.get();
    List<dynamic> storyLines = [];
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      storyLines = List<dynamic>.from(data['storyLines'] ?? []);
    }

    // Add the new story line to the list
    storyLines.add(wordController.text);

    // Update the document with the updated list of story lines
    await documentRef.update({
      'storyLines': FieldValue.arrayUnion(storyLines),
    });

    // Clear the text field
    wordController.clear();

    // Navigate to the admin home screen after submitting
    Navigator.pop(context);
  }

  void saveCorrectAnswer() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef =
        firestore.collection('incomplete_story').doc(widget.documentId);

    // Update the document with the correct answer
    await documentRef.update({
      'correctAnswer': correctAnswerController.text,
    });

    // Clear the text field
    correctAnswerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Document'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(labelText: 'Story Line'),
              enabled: true,
              autofocus: true,
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: correctAnswerController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Correct Answer'),
              enabled: true,
              autofocus: true,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveDocument,
                  child: Text('Save'),
                ),
                ElevatedButton(
                  onPressed: submitDocument,
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: saveCorrectAnswer,
                  child: Text('Save Correct Answer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
