import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewCorrectAnswerScreen extends StatefulWidget {
  final String imageUrl;
  final String? userStory;
  final String? adminStory;

  ViewCorrectAnswerScreen({
    required this.imageUrl,
    this.userStory,
    this.adminStory,
  });

  @override
  State<ViewCorrectAnswerScreen> createState() => _ViewCorrectAnswerScreenState();
}

class _ViewCorrectAnswerScreenState extends State<ViewCorrectAnswerScreen> {
  String? displayAdminStory;

  @override
  void initState() {
    super.initState();
    displayAdminStory = widget.adminStory;
    fetchAdminStory();
  }

  void fetchAdminStory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('imageUrl', isEqualTo: widget.imageUrl)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final adminStory = snapshot.docs[0]['story'];
        setState(() {
          displayAdminStory = adminStory;
        });
      } else {
        setState(() {
          displayAdminStory = 'The correct story is not available yet.';
        });
      }
    } catch (e) {
      print('Error fetching admin story: $e');
      setState(() {
        displayAdminStory = 'Error fetching the correct story.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Correct Answer'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
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
            if (displayAdminStory != null)
              Column(
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
                  Text(displayAdminStory!),
                ],
              ),
            if (displayAdminStory == null) // Show a demo text if the adminStory is null
              Column(
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
                  Text('The correct story is not available yet.'),
                ],
              ),
            SizedBox(height: 16.0),
            if (widget.userStory != null)
              Column(
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
                  Text(widget.userStory!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
