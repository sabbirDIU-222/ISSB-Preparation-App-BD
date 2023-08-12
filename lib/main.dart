import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quizapplication/services/sharedPref.dart';
import 'package:quizapplication/widget/iqQuizwidget/Iqpage.dart';
import 'package:quizapplication/home_screen_preli/home.dart';
import 'package:quizapplication/incomplete_story_writing/incompleteStory.dart';
import 'package:quizapplication/login_signup_functionality/log_in.dart';
import 'package:quizapplication/home_screen_preli/preliminaryDetail.dart';
import 'package:quizapplication/trainer_screen_ui/trainerHome.dart';
import 'package:quizapplication/trainer_screen_ui/trainerProfile.dart';
import 'package:quizapplication/widget/new_PPDT/iamge_Set.dart';
import 'package:quizapplication/widget/planningExersize/exersize_set.dart';
import 'package:quizapplication/word_association_test/watQuestion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/chat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final User? user = FirebaseAuth.instance.currentUser;
  final ChatService chatService = ChatService();
  await SharedPreferencesManager.getInstance();
  final bool? isUserLoggedIn = SharedPreferencesManager.instance?.isLoggedIn;

  runApp(MyApp(user: user, isUserLoggedIn: isUserLoggedIn!));
}

class MyApp extends StatelessWidget {
  final User? user;
  final bool isUserLoggedIn;

  MyApp({
    Key? key,
    required this.user,
    required this.isUserLoggedIn,
  }) : super(key: key);

  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        color: Color(0xFFCCFFCC),
        debugShowCheckedModeBanner: false,
        title: 'TRD',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Color(0xFFCCFFCC),
        ),
        home: user != null || isUserLoggedIn == true ? Home() : LogIn(),
        routes: {
          '/logIn': (context) => LogIn(),
          '/home': (context) => Home(),
          '/detail': (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            final collectionName = arguments?['collectionName'] as String?;
            final appBarTitle = arguments?['appBarTitle'] as String?; // Add this line
            return PreliminarySection(
              collectionName: collectionName.toString(),
              appBarTitle: appBarTitle.toString(), // Pass the appBarTitle
            );
          },


          '/iq': (context) => IQScreen(),
          '/ppdt': (context) => ImageSetListScreen(),
          '/storywriting': (context) => ExerciseQusSet(),
          '/wat': (context) => WatQuestionSet(),
          '/incompletestory': (context) => IncompleteStoryScreen(),
          '/trainerprofile': (context) => TrainerProfile(),
          '/trainerHome': (context) => TrainerHome(),
        },
      ),
    );
  }

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}
