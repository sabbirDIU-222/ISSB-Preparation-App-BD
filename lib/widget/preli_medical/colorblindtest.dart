import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ColorBlindTestScreen extends StatefulWidget {
  @override
  _ColorBlindTestScreenState createState() => _ColorBlindTestScreenState();
}

class _ColorBlindTestScreenState extends State<ColorBlindTestScreen> {
  List<TestItem> testItems = []; // List of image-answer pairs

  // Fetch data from Firebase
  void fetchDataFromFirebase() async {
    try {
      final collectionSnapshot = await FirebaseFirestore.instance.collection('testItems').get();

      collectionSnapshot.docs.forEach((document) {
        final data = document.data() as Map<String, dynamic>;

        final image = data['image'] as String;

        final options = (data['options'] as List<dynamic>).cast<String>().toList();

        final correctAnswer = int.parse(data['correctoption'] as String); // Convert to int

        final testItem = TestItem(image: image, options: options, correctAnswer: correctAnswer);
        setState(() {
          testItems.add(testItem);
        });
      });
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data from Firebase when the screen is loaded
    fetchDataFromFirebase();
  }

  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text('If You Are not selected in medical\nThen we are so sorry\nplesase take care'),
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
        title: Text('Color Blind Test'),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            _showSuggestionDialog();
          }, icon: Icon(Icons.note_alt,color: Colors.white,)),
        ],
      ),
      body: ListView.builder(
        itemCount: testItems.length,
        itemBuilder: (context, index) {
          final TestItem testItem = testItems[index];
          final selectedIndex = testItem.selectedIndex;

          return Column(
            children: [
              Image.network(testItem.image), // Display the test image
              Column(
                children: List.generate(testItem.options.length, (optionIndex) {
                  final bool isCorrectAnswer = optionIndex == testItem.correctAnswer;
                  final Color activeColor = selectedIndex == optionIndex
                      ? isCorrectAnswer
                      ? Colors.green
                      : Colors.red
                      : Colors.black;

                  return RadioListTile<int>(
                    title: Text(testItem.options[optionIndex]),
                    value: optionIndex,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        testItem.selectedIndex = value; // Update the selectedIndex for the current TestItem
                      });
                    },
                    activeColor: activeColor,
                    selected: selectedIndex == optionIndex,
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TestItem {
  final String image;
  final List<String> options;
  final int correctAnswer;
  int? selectedIndex;

  TestItem({required this.image, required this.options, required this.correctAnswer});
}
