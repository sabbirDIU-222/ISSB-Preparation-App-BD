import 'package:flutter/material.dart';
Widget orangeButton(BuildContext context, String label, buttonWidth, buttonColor){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: buttonWidth,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}