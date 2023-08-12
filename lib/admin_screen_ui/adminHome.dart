import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/widget/planningExersize/exersize_set.dart';
import 'package:quizapplication/word_association_test/watQuestion.dart';
import '../widget/iqQuizwidget/Iqpage.dart';
import '../home_screen_preli/home.dart';
import '../incomplete_story_writing/incompleteStory.dart';
import '../widget/new_PPDT/iamge_Set.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        title: Text('Welcome Admin'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: SignOutFunction, icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Number of tiles
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0), // Add vertical padding
            child: Container(
              height: 60, // Height of each tile
              decoration: BoxDecoration(
                color: Color.fromRGBO(69, 75, 27, 1),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: ListTile(
                title: _getTitle(index),
                onTap: () {
                  _navigateToPage(context, index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void SignOutFunction() async {
    try {
      await FirebaseAuth.instance.signOut();
      //removeTrainerEmail();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ));
    } catch (e) {
      print('Sign-out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign-out failed. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _getTitle(int index) {
    switch (index) {
      case 0:
        return const Text('IQ', style: TextStyle(color: Colors.white));
      case 1:
        return const Text('PPDT', style: TextStyle(color: Colors.white));
      case 2:
        return const Text('Planning Exersize', style: TextStyle(color: Colors.white));
      case 3:
        return const Text('WAT', style: TextStyle(color: Colors.white));
      case 4:
        return const Text('Incomplete story', style: TextStyle(color: Colors.white));
      default:
        return const SizedBox.shrink();
    }
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => IQScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageSetListScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseQusSet()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => WatQuestionSet()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => IncompleteStoryScreen()));
        break;
    }
  }
}
