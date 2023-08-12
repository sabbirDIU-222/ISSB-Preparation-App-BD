import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapplication/widget/preli_vaiva/quesitionlist.dart';
import 'package:quizapplication/widget/preli_vaiva/question.dart';

class AnswerScreen extends StatefulWidget {
  final Question question;

  AnswerScreen({required this.question});

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool showError = false;


  void _submitAnswer() async {
    String answer = _answerController.text;

    if (answer.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }

    // Save the answer to Firebase
    await FirebaseFirestore.instance.collection('answers').add({
      'question': widget.question.question,
      'answer': answer,
    });

    setState(() {
      widget.question.isAnswered = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Answer Submitted'),
          content: Text('Your answer has been submitted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                _answerController.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionListScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question.question),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _answerController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Answer',
                  errorText: showError ? 'Please write your answer' : null,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: _submitAnswer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16), // Increase the vertical padding
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Increase the border radius
                ),
              ),
              child: Text(
                'Submit Answer',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

