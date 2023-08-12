import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quizapplication/widget/preli_vaiva/question.dart';
import 'ans_Screen.dart';
import 'answerlist_screen.dart';

class QuestionListScreen extends StatefulWidget {
  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  List<Question> questions = [
    Question(
      question: 'Tell me about yourself',
      correctAnswer: 'Sample correct answer for "Tell me about yourself"',
    ),
    Question(
      question: 'What is UN',
      correctAnswer: 'Sample correct answer for "What is UN"',
    ),
    Question(
      question: 'Who is the chief of Army staff of Bangladesh?',
      correctAnswer: 'General SM shafiuddin',
    ),
    Question(
      question: 'Why you want to join in Army/Navy/Airforce?',
      correctAnswer: 'Tell the absoulate reason. Be brave and confidance.',
    ),
    Question(
      question: 'What is BMA?',
      correctAnswer: 'Bangladesh Military Academy.',
    ),
    Question(
      question: 'What is the current problem in Bangladesh?',
      correctAnswer: 'This answer may vary. According you, you have your own opinion',
    ),
    Question(
      question: 'Is anyone push you to join Military?',
      correctAnswer: 'This answer may vary. According you, you have your own opinion',
    ),
    Question(
      question: 'Who is the president/prime-minister of Bangladesh?',
      correctAnswer: 'This is a tricky question, we all know that our\npresident or prime-minister name. But when they ask it, you must ans this\nwith Honorable prefix',
    ),
    Question(
      question: 'What is your father?',
      correctAnswer: 'This question does not mean that who is your father. It mean that what your father is doing.\nBe proud whatever your father is doing',
    ),
    Question(
      question: 'Describe your family shortly',
      correctAnswer: 'You can told them of your every family member relation and what are they doing.',
    ),
    Question(
      question: 'Introduce Yourself. Please',
      correctAnswer: 'This is the must coming question. You will tell about yourself shortly but not\nabout your whole life story or your father story. You need to tell them how much interested\nyou are about to join the Military.',
    ),
    Question(
      question: 'Why should we choose you?',
      correctAnswer: 'In this question you need to describe yourself or express yourself that you are interested to join in Military.',
    ),


  ];


  bool hasAnsweredQuestions = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question List'),
          actions: [
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerListScreen(questions: questions),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];

            return ListTile(
              title: Text(question.question),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnswerScreen(question: question),
                    ),
                  ).then((result) {
                    // Check if the user has answered at least one question
                    setState(() {
                      question.isAnswered = result ?? false;
                    });
                  });
                },
                child: Text('Your Answer'),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final answeredQuestions = questions.where((question) => question.isAnswered).toList();
            final progressResult = answeredQuestions.length / questions.length * 10;
            final randomResult = Random().nextInt(11) + 10; // Random number between 90 and 100
            final result = answeredQuestions.isNotEmpty ? progressResult : randomResult;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Don\'t be panicked!\nThe result isn\'t absulate '),
                  content: Text('Your progress: ${result.toStringAsFixed(0)}%'),
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
          },
          child: Icon(Icons.visibility),
        ),
      ),
      );
  }

  bool checkIfAnsweredQuestions() {
    for (var question in questions) {
      if (question.isAnswered) {
        return true;
      }
    }
    return false;
  }
}



