import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQuizData(String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete();
  }

  Future<void> addQuestionData(Map<String, dynamic> questionData, String quizId,
      String questionId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .set(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateQuestionData(Map<String, dynamic> questionData,
      String quizId, String questionId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .update(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<void> deleteQuestionData(String quizId, String questionId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
}
