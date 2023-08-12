import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const CardWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String collectionName;
        String appBarTitle;
        if (text == 'Medical') {
          collectionName = 'preliminary';
          appBarTitle = 'Medical';
        } else if (text == 'vaiva') {
          collectionName = 'vaiva_collection';
          appBarTitle = 'vaiva';
        } else if (text == 'Written') {
          collectionName = 'written_collection';
          appBarTitle = 'Written';
        } else if (text == 'call up letter') {
          collectionName = 'Call_Up_Letter';
          appBarTitle = 'call up letter';
        } else {
          return; // Do nothing if none of the above conditions match
        }
        Navigator.pushNamed(context, '/detail',
            arguments: {'collectionName': collectionName, 'appBarTitle': appBarTitle});
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(height: 8.0),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
