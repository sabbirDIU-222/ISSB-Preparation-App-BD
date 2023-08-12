import 'package:flutter/material.dart';
import 'package:quizapplication/services/quizDBservice.dart';
import 'package:quizapplication/widget/iqQuizwidget/button_widget.dart';
import 'package:random_string/random_string.dart';

import 'add_quiz_question.dart';

class AdminCreateQuiz extends StatefulWidget {
  const AdminCreateQuiz({Key? key}) : super(key: key);

  @override
  State<AdminCreateQuiz> createState() => _AdminCreateQuizState();
}

class _AdminCreateQuizState extends State<AdminCreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizTitle, quizId, quizDescription;
  bool _isLoading = false;

  DatabaseService service = DatabaseService();

  _createQuizOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);
      Map<String, String> quizData = {
        "quizId": quizId,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription,
      };

      await service.addQuizData(quizData, quizId).then((value) => {
            setState(() {
              _isLoading = false;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('name your set'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Quiz Title"),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                      validator: (val) {
                        return val!.isEmpty ? "Enter quiz title" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: "Quiz Description"),
                      onChanged: (val) {
                        quizDescription = val;
                      },
                      validator: (val) {
                        return val!.isEmpty
                            ? "Enter quiz description"
                            : null;
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => _createQuizOnline(),
                      child: orangeButton(
                          context,
                          'Create Quiz',
                          MediaQuery.of(context).size.width - 48,
                          Colors.deepOrangeAccent),
                    ),
                    SizedBox(height: 40.0)
                  ],
                ),
              )),
    );
  }
}
