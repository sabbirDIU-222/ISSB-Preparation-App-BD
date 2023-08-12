import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../home_screen_preli/home.dart';

class FireDB {

  createNewUser(
      String name,
      String email,
      String uid,
      BuildContext context,
      ) async {
    if (await getUser(uid)) {
      showSimpleNotification(
        Text('USER ALREADY EXISTS'),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ),
      );
    } else {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'uid': uid, // Set the user ID in the document
      }).then((value) => print('Create new user is complete'));
    }
  }




// checking if the user already has an account or not
  Future<bool> getUser(String uid) async {
    final DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return false;
    }

    final Map<String, dynamic>? data =
    snapshot.data() as Map<String, dynamic>?;

    if (data == null ||
        data['name'] == null ||
        data['email'] == null) {
      return false;
    }

    return true;
  }
}
