import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  final String correctStory;
  final String userStory;

  StoryScreen({required this.correctStory, required this.userStory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Correct Story:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(correctStory),
            SizedBox(height: 16.0),
            Text(
              'Your Story:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(userStory),
          ],
        ),
      ),
    );
  }
}
