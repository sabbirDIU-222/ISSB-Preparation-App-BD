import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/widget/iqQuizwidget/create_iq_quiz.dart';
import 'package:quizapplication/widget/iqQuizwidget/playQuiz.dart';
import '../../services/quizDBservice.dart';

class IQScreen extends StatefulWidget {
  @override
  State<IQScreen> createState() => _IQScreenState();
}

class _IQScreenState extends State<IQScreen> {
  late User user;
  late Stream<QuerySnapshot> quizStream;
  DatabaseService service = DatabaseService();
  bool _isLoading = true;

  // check admin user id
  bool isAdmin() {
    return user.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<QuerySnapshot>(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data() as Map<String, dynamic>?;

                if (data == null) {
                  // Handle the situation where data is missing or malformed
                  return Container();
                }

                final title = data["quizTitle"] as String?;
                final description = data["quizDescription"] as String?;
                final quizId = data["quizId"] as String?;

                if (title == null || description == null || quizId == null) {
                  // Handle the situation where required fields are missing or null
                  return Container();
                }

                return QuizTile(
                  title: title,
                  description: description,
                  quizId: quizId,
                );
              },
            );
          } else {
            return Container(
              child: Center(
                child: Text(
                  "No Quiz Available",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }
        },
      ),
    );
  }



  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    service.getQuizData().then((value) {
      setState(() {
        quizStream = value;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First TEST'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : quizList(),
      floatingActionButton: isAdmin()
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminCreateQuiz(),
            ),
          );
        },
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}


class QuizTile extends StatelessWidget {
  final String title;
  final String description;
  final String quizId;

  QuizTile({required this.title, required this.description, required this.quizId});


  Future<void> deleteQuizData(String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    bool isAdmin() {
      return user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
    }

    bool isAdminUser = isAdmin();


    void _deleteQuiz() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Quiz'),
            content: Text('Are you sure you want to delete this quiz?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteQuizData(quizId);
                  Navigator.of(context).pop();
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PlayQuiz(setId: quizId);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF9D9D56),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Sirin',
                      color: Colors.white,
                      letterSpacing: 1.4,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 1.5,
                      fontSize: 14,
                      fontFamily: 'Open',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdminUser)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: _deleteQuiz,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
