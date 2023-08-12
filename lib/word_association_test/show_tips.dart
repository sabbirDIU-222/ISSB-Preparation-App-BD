import 'package:flutter/material.dart';

class TipsPopupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tips'),
      icon: Icon(Icons.lightbulb,color: Colors.amber,),
      content: Text(
        'Here are some tips for the Word association test:\n\n'
            '1. This test bring your inner psychology\n'
            '2. So be positive.\n'
            '3. Be Time consuming. While write',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}