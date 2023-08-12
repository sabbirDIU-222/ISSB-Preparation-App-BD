import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home_screen_preli/home.dart';

class StoryWriting extends StatefulWidget {
  final String setId;

  const StoryWriting({required this.setId});

  @override
  _StoryWritingState createState() => _StoryWritingState();
}

class _StoryWritingState extends State<StoryWriting> {
  List<String> images = [];
  int currentImageIndex = 0;
  Timer? timer;
  bool isTimeUp = false;
  int totalDuration = 0;
  int currentDuration = 0;
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
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('storywriting')
        .doc(widget.setId)
        .get();

    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data.isNotEmpty) {
      List<String> urls = List<String>.from(data['imageUrl'] ?? []);
      setState(() {
        images = urls;
        totalDuration = urls.length * 50;
        currentDuration = totalDuration;
        currentImageIndex = 0; // Reset the image index
      });

      startTimer();
    }
  }


  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (currentDuration > 0) {
          currentDuration--;
          if (currentDuration % 50 == 0) {
            currentImageIndex = (currentImageIndex + 1) % images.length;
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatDuration(int duration) {
    int minutes = (duration / 60).floor();
    int seconds = duration % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : minutes.toString();
    String secondsStr = (seconds < 10) ? '0$seconds' : seconds.toString();
    return '$minutesStr:$secondsStr';
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
                  MaterialPageRoute(builder: (context) => Home()),
                );
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
        title: Text('Image to Story'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                isTimeUp ? 'Your time is up' : '${timer?.tick ?? ''}',
                style: TextStyle(fontSize: 20,color: Colors.cyan),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Timer: ${formatDuration(currentDuration)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          images.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: images[currentImageIndex],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )
              : CircularProgressIndicator(),
          SizedBox(height: 40,),
          ElevatedButton(
            child: Text('Quit'),
            onPressed: showQuitConfirmationDialog,
          ),
          SizedBox(height: 50,),
          Center(

            child: Text(
              'Remeber that, In ISSB the time will be short to write\n story fromo picture.Make your best story within the time. If you don\'t complete it. Don\'t WORRY\n Do your Best on next exam',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
