import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncompleteStoryDetailsScreen extends StatefulWidget {
  final String setId;

  const IncompleteStoryDetailsScreen(this.setId);

  @override
  State<IncompleteStoryDetailsScreen> createState() =>
      _IncompleteStoryDetailsScreenState();
}

class _IncompleteStoryDetailsScreenState
    extends State<IncompleteStoryDetailsScreen> {
  final firestore = FirebaseFirestore.instance;
  List<dynamic> stories = [];
  String? correctAnswer;
  String? userStory;
  bool isSubmitted = false; // Flag to track whether user submitted the story
  String? userStoryError;
  final TextEditingController _userStoryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchData();
    _userStoryController.text = userStory ?? ''; // Set the initial value of the TextField

  }

  @override
  void dispose() {
    _userStoryController.dispose();
    super.dispose();
  }


  void _fetchData() async {
    final document =
    await firestore.collection('incomplete_story').doc(widget.setId).get();
    final data = document.data() as Map<String, dynamic>;

    setState(() {
      stories = data['storyLines'] ?? [];
      correctAnswer = data['correctAnswer'] as String?;
    });
  }

  int calculateEditDistance(String s1, String s2) {
    int n = s1.length;
    int m = s2.length;

    List<List<int>> dp = List.generate(n + 1, (_) => List.filled(m + 1, 0));

    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= m; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + dp[i - 1][j - 1];
        }
      }
    }

    return dp[n][m];
  }


  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text('* This is a self task preparation\n'
            '* In incomplete story writing task your answer and other answer will not be same\n'
        '* So dont be panicked\n'
        '* In Correct Anser Section I give you a sample correct answer that will be predict as correct ans'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Got It!'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Story Details'),
        actions: [
          IconButton(onPressed: (){
            _showSuggestionDialog();
          }, icon: Icon(Icons.note_alt,color: Colors.white,)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  color: Color(0xFFF5F5DC),
                  elevation: 2.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      stories.join("\n"),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        letterSpacing: 1.4,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              if (!isSubmitted) // Show the text field and submit button if the user has not submitted yet
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _userStoryController,
                      onChanged: (value) {
                        userStory = value.trim();
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Write the Full Story',
                        errorText: userStoryError,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (userStory != null && userStory!.trim().isNotEmpty) {
                            isSubmitted = true;
                            userStoryError = null;

                            int editDistance = calculateEditDistance(userStory!, correctAnswer!);

                            int similarityThreshold = 5;

                            if (editDistance <= similarityThreshold) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Prediction'),
                                  content: Text('Your psychology is good!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // User's input is different from the correct answer
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Prediction'),
                                  content: Text('Your psychology need to upgrade!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            userStoryError = 'Please write down your story';
                          }
                        });
                      },
                      child: Text('Submit'),
                    ),

                  ],
                ),
              if (isSubmitted) // Show the correct answer and user's story only after the user submits
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Correct Answer: \n$correctAnswer',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,fontFamily: 'Open'),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                    Divider(color: Colors.grey,),
                    Text(
                      'Your Story: \n$userStory' ,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18,),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

}





