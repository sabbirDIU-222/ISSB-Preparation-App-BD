import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapplication/app_side_drawer/side_drawer.dart';
import 'package:quizapplication/home_screen_preli/home.dart';
import 'package:flutter/scheduler.dart' show Ticker;

class WATScreen extends StatefulWidget {
  final String setId;
  WATScreen({required this.setId});

  @override
  _WATScreenState createState() => _WATScreenState();
}

class _WATScreenState extends State<WATScreen> {
  List<String> words = [];
  int currentWordIndex = 0;
  Timer? timer;
  bool isTimeUp = false;
  int totalDuration = 0;
  int selectedSetIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    final firestore = FirebaseFirestore.instance;
    final setDoc = await firestore.collection('words').doc(widget.setId).get();

    final data = setDoc.data();
    if (data != null && data['words'] is List) {
      setState(() {
        words = List<String>.from(data['words']);
        totalDuration = words.length * 5;
        startTimer();
      });
    }
  }


  void startTimer() {
    const slideDuration = Duration(seconds: 5);
    var elapsedTime = Duration();

    timer = Timer.periodic(slideDuration, (Timer _timer) {
      setState(() {
        currentWordIndex++;
      });
      elapsedTime += slideDuration;

      if (elapsedTime >= Duration(seconds: totalDuration)) {
        _timer.cancel();
        setState(() {
          isTimeUp = true;
        });
      }
    });
  }

  void showQuitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quit'),
          content: Text('Are you sure you want to quit?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
                // Perform any actions you want when the user quits here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Slideshow'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Container(
              padding: EdgeInsets.all(16),

              child: Text(
                isTimeUp ? 'Your time is up' : '${timer?.tick ?? ''}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                words.isNotEmpty
                    ? words[currentWordIndex % words.length]
                    : 'Loading...',
                style: TextStyle(fontSize: 30,fontFamily: 'Sirin',fontWeight: FontWeight.w600,letterSpacing: 2.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18.0,bottom: 18.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.symmetric(vertical: 13)

              ),
              child: Container(
                width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('Quit',style: TextStyle(fontSize: 18.0),)),
              onPressed: showQuitConfirmationDialog,
            ),
          ),
        ],
      ),
    );
  }
}
