import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './firedb.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signinWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user != null) {
      assert(!user.isAnonymous);

      assert(await user.getIdToken() != null);

      await FireDB().createNewUser(
        user.displayName ?? '', // Add null check
        user.email ?? '', // Add null check
        user.uid, // Pass userCredential to createNewUser
        context,
      );

      // save the user data
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    print('error occurred');
    print(e);
  }
}

