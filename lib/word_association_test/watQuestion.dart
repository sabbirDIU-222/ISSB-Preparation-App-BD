import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/word_association_test/show_tips.dart';

import 'wat.dart';

class WatQuestionSet extends StatefulWidget {
  @override
  _WatQuestionSetState createState() => _WatQuestionSetState();
}

class _WatQuestionSetState extends State<WatQuestionSet> {
  List<DocumentSnapshot> questionSets = [];
  late User user;

  void showTipsPopup() {
    showDialog(
      context: context,
      builder: (context) => TipsPopupScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchQuestionSets();
    user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> fetchQuestionSets() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('words').get();

    setState(() {
      questionSets = snapshot.docs;
    });
  }

  Future<void> deleteQuestionSet(String setId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('words').doc(setId).delete();

    fetchQuestionSets();
  }

  void createNewDocument() async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('words');

    final newDocumentRef = await collectionRef.add({});

    final newDocumentId = newDocumentRef.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDocumentScreen(documentId: newDocumentId),
      ),
    );
  }

  bool isAdmin() {
    return user.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Association Test'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              showTipsPopup();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questionSets.length,
        itemBuilder: (context, index) {
          final questionSet = questionSets[index];
          final setId = questionSet.id;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Card(
              color: Color(0xFF6BAF7D),
              child: ListTile(
                leading: Icon(
                  Icons.timelapse,
                  color: Colors.white70,
                ),
                title: Text(
                  'WAT Set ${index + 1}',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontFamily: 'Open',
                      letterSpacing: 1.4),
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
                                    deleteQuestionSet(setId);
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
                    : Text(''),
                onTap: () {
                  // Handle the selection of a question set here
                  // You can navigate to the WAT screen passing the selected setId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WATScreen(setId: setId),
                    ),
                  );
                },
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

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  void saveDocument() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef = firestore.collection('words').doc(widget.documentId);

    final snapshot = await documentRef.get();
    List<String> words = [];
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      words = List<String>.from(data['words'] ?? []);
    }

    words.add(wordController.text);

    await documentRef.set({
      'words': words,
    }, SetOptions(merge: true));

    wordController.clear();
  }

  void submitDocument() async {
    final firestore = FirebaseFirestore.instance;
    final documentRef = firestore.collection('words').doc(widget.documentId);

    final snapshot = await documentRef.get();
    List<String> words = [];
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      words = List<String>.from(data['words'] ?? []);
    }

    words.add(wordController.text);

    await documentRef.update({
      'words': words,
    });

    wordController.clear();

    Navigator.pop(context);
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
              decoration: InputDecoration(labelText: 'wat'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
