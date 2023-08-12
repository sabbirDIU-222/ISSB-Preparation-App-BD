import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';

import 'package:quizapplication/widget/planningExersize/planning.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String imageUrl;
  final int itemIndex;

  ExerciseDetailScreen({required this.imageUrl, required this.itemIndex});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  String description = '';
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDescription();
  }

  Future<void> fetchDescription() async {
    try {
      String descriptionRef =
          'exerciseDescriptions/description${widget.itemIndex}.txt';
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(descriptionRef);
      String descriptionText =
          await ref.getData().then((data) => String.fromCharCodes(data!));
      setState(() {
        description = descriptionText;
        _descriptionController.text =
            description; // Pre-populate the text field with the fetched description
      });
    } catch (e) {
      print('Error fetching description: $e');
      setState(() {
        description = 'Error loading description';
      });
    }
  }

  bool isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  Future<void> saveDescription() async {
    try {
      String descriptionRef =
          'exerciseDescriptions/description${widget.itemIndex}.txt';
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(descriptionRef);

      // Get the description text from the text field
      String newDescription = _descriptionController.text;

      // Encode the description text as bytes using Uint8List
      Uint8List descriptionData = Uint8List.fromList(newDescription.codeUnits);

      // Upload the updated description to Firebase Storage
      await ref.putData(descriptionData);

      setState(() {
        description = newDescription;
      });

      print('Description saved successfully');
    } catch (e) {
      print('Error saving description: $e');
    }
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(9.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            if (isAdmin())
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 18,fontFamily: 'Open',fontWeight: FontWeight.w400,letterSpacing: 1),
                textAlign: TextAlign.justify,
              ),
            ),
            if (isAdmin())
              ElevatedButton(
                onPressed: saveDescription,
                child: Text('Save Description'),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.050,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Container(
                  width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Share Your Plan',style: TextStyle(fontSize: 18),)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlanningScreen(imageUrl: widget.imageUrl),
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
