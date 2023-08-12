import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/widget/preli_vaiva/question.dart';

class AnswerListScreen extends StatefulWidget {
  final List<Question> questions; // Add this line to receive the questions list

  AnswerListScreen({required this.questions});
  @override
  _AnswerListScreenState createState() => _AnswerListScreenState();
}

class _AnswerListScreenState extends State<AnswerListScreen> {
  List<Answer> answers = [];

  @override
  void initState() {
    super.initState();
    fetchAnswers();
    answers = Answer.fromQuestionList(widget.questions); // Access the questions list from QuestionListScreen
  }



  Future<List<Answer>> fetchAnswers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('answers').get();
      return querySnapshot.docs.map((doc) => Answer.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching answers: $e');
      return []; // Return an empty list if there's an error
    }
  }


  Future<void> deleteAllAnswers() async {
    try {
      await FirebaseFirestore.instance.collection('answers').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      setState(() {
        answers = [];
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deletion Successful'),
            content: Text('All answers have been deleted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error deleting answers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Answers'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteAllAnswers();
            },
          ),
        ],
      ),
      body: answers.isEmpty
          ? Center(
        child: Text(
          'You have not answered any questions',
          style: TextStyle(color: Colors.red),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.only(top: 9.0,bottom: 19.0),
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final answer = answers[index];

          return ListTile(
            title: Text(answer.question),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Answer: ${answer.userAnswer}'),
                Text('Correct Answer: ${answer.correctAnswer}',maxLines: 2,),
              ],
            ),
          );
        },
      ),

    );
  }
}

class Answer {
  final String question;
  final String userAnswer;
  String correctAnswer;

  Answer({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
  });

  factory Answer.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final question = data['question'] as String? ?? '';
    final userAnswer = data['answer'] as String? ?? '';
    final correctAnswer = '';

    return Answer(
      question: question,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    );
  }

  static List<Answer> fromQuestionList(List<Question> questions) {
    return questions
        .map((question) => Answer(
      question: question.question,
      userAnswer: '', // Initialize userAnswer with an empty string
      correctAnswer: question.correctAnswer,
    ))
        .toList();
  }
}

