import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/widget/iqQuizwidget/play_quiz_widget.dart';
import '../../services/quizDBservice.dart';
import 'iq_Result.dart';
import '../../model/questionmodel.dart';

class PlayQuiz extends StatefulWidget {
  String setId;
  PlayQuiz({required this.setId});

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
Stream? infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService service = new DatabaseService();
  late QuerySnapshot querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    Map<String, dynamic>? data =
    questionSnapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      questionModel.question = data["question"];

      List<String> options = [
        data["option1"],
        data["option2"],
        data["option3"],
        data["option4"],
      ];
      options.shuffle();

      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      questionModel.option3 = options[2];
      questionModel.option4 = options[3];

      questionModel.correctOption = data["correctAnswer"];
      questionModel.correctAnswer = data["correctAnswer"];
      questionModel.answered = false;
    }

    return questionModel;
  }

  @override
  void initState() {
    service.getQuestionData(widget.setId).then((value) {
      querySnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot.docs.length;
      _isLoading = false;
      setState(() {});
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(
        Duration(milliseconds: 100),
            (x) => [_correct, _incorrect],
      );
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('IQ TEST'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InfoHeader(
                length: querySnapshot.docs.length,
              ),
              SizedBox(
                height: 10,
              ),
              querySnapshot.docs == null
                  ? Container(
                child: Center(
                  child: Text("No Question Available",
                      style: TextStyle(
                          fontSize: 18, color: Colors.red)),
                ),
              )
                  : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromSnapshot(
                          querySnapshot.docs[index]),
                      index: index,
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done_outline_sharp),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                      correct: _correct, incorrect: _incorrect, total: total)));
        },
      ),
    );
  }
}

//------------------info header-------------------

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  void dispose() {
    infoStream = null; // Dispose the stream when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
          height: 40,
          margin: EdgeInsets.only(left: 14),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              NumberOfQuestionTile(
                text: "Total",
                number: widget.length,
              ),
              NumberOfQuestionTile(
                text: "Correct",
                number: _correct,
              ),
              NumberOfQuestionTile(
                text: "Incorrect",
                number: _incorrect,
              ),
              NumberOfQuestionTile(
                text: "NotAttempted",
                number: _notAttempted,
              ),
            ],
          ),
        )
            : Container();
      },
    );
  }
}


// ------------------------------------------------

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
                option: "A",
                description: widget.questionModel.option1,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
                option: "B",
                description: widget.questionModel.option2,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
                option: "C",
                description: widget.questionModel.option3,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
                option: "D",
                description: widget.questionModel.option4,
                correctAnswer: widget.questionModel.correctAnswer,
                optionSelected: optionSelected),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
